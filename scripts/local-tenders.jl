using QuackIO
using DataFramesMeta
using CairoMakie

df = QuackIO.read_parquet(DataFrame, "data/intermediate/local-region.parquet")
df_plot = sort(df, :share, rev = true)  # Highest first

function normaliza_region(region)
    region = lowercase(region)
    if occursin(r"ays[eé]n del general carlos ib[aá]ñez del campo", region)
        return "Aysén"
    elseif occursin(r"magallanes y de la ant[aá]rtica", region)
        return "Magallanes"
    elseif occursin(r"ñuble", region)
        return "Ñuble"
    elseif occursin(r"maule", region)
        return "Maule"
    elseif occursin(r"libertador general bernardo o", region)
        return "O'Higgins"
    elseif occursin(r"metropolitana de santiago", region)
        return "Santiago"
    elseif occursin(r"bi[oó]b[ií]o", region)
        return "Biobío"
    elseif occursin(r"araucan[ií]a", region)
        return "La Araucanía"
    elseif occursin(r"los lagos", region)
        return "Los Lagos"
    else
        # Elimina "región de", "region de", "región", "region" al inicio
        region = replace(region, r"^(regi[oó]n(\s+de)?\s+)" => "")
        # Capitaliza la primera letra de cada palabra
        return join(uppercasefirst.(split(region)), " ")
    end
end

region_labels = [normaliza_region(r) for r in df_plot.region]

fig = Figure(resolution = (800, 1000), backgroundcolor = :white)
ax = Axis(
    fig[1, 1];
    title = "Proportion of tenders awarded to local suppliers by region",
    yreversed = false,
    titlefont = "sans-serif",
    titlesize = 17,
)

ax.backgroundcolor = :white

positions = 1:length(region_labels)

barplot!(
    ax,
    positions,
    df_plot.share;
    color = "#1565C0",  # Dark blue
    width = 0.8
)

ax.xticks = (positions, region_labels)
ax.xlabel = ""  # Remove x axis label
ax.ylabel = "Proportion (%)"

ax.xgridvisible = false
ax.ygridvisible = false

# Set x-axis to fit bars exactly (no extra space)
xlims!(ax, 0.5, length(region_labels) + 0.5)

# Set y-axis so the max value is a bit higher than the tallest bar
max_share = maximum(df_plot.share)
ylims!(ax, 0, max_share == 0 ? 1 : max_share * 1.05)

# Rotate x-tick labels
ax.xticklabelrotation = pi/4  # 45 degrees

fig

save("nombre_del_archivo.png", fig)