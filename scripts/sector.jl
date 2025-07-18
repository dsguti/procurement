using CairoMakie
using DataFrames
using QuackIO

# Load the Parquet file
df = QuackIO.read_parquet(DataFrame, "data/intermediate/local-sector.parquet")

# Replace missing sector labels with "Sin dato"
labels = coalesce.(df.sector, "Sin dato")
values = df.share

# Remove "Sin dato", "SIN DATO", "SINDATO" and "Otros" (case-insensitive)

labels = labels[mask]
values = values[mask]

# Translate sector names to English (including new translations)
translation = Dict(
    "Salud" => "Health",
    "Educación" => "Education",
    "Obras Públicas" => "Public Works",
    "Defensa" => "Defense",
    "Justicia" => "Justice",
    "Interior" => "Interior",
    "Economía" => "Economy",
    "Agricultura" => "Agriculture",
    "Transporte" => "Transport",
    "Minería" => "Mining",
    "Energía" => "Energy",
    "Cultura" => "Culture",
    "Trabajo" => "Labor",
    "Desarrollo Social" => "Social Development",
    "Relaciones Exteriores" => "Foreign Affairs",
    "Bienes Nacionales" => "National Assets",
    "Deporte" => "Sports",
    "Medio Ambiente" => "Environment",
    "Legislativo y Judicial" => "Legislative and Judicial",
    "Municipalidades" => "Municipalities",
    "FFAA" => "Armed Forces",
    "Gob. Central, Universidades" => "Central Government & Universities"
)

# Apply translation (after filtering, so lengths always match)
labels = [get(translation, strip(label), label) for label in labels]

# Sort from highest to lowest (apply to both labels and values)
sorted_idx = sortperm(values, rev=true)
labels = labels[sorted_idx]
values = values[sorted_idx]

positions = 1:length(labels)

# Create the figure and axis
fig = Figure(resolution = (900, 700), backgroundcolor = :white)
ax = Axis(
    fig[1, 1];
    title = "Proportion of tenders awarded to local suppliers by sector",
    xticks = (positions, labels),
    titlefont = "sans-serif",
    titlesize = 17,
    xticklabelsize = 13,
)

ax.backgroundcolor = :white

# Plot vertical bars (bars on y axis)
barplot!(
    ax,
    positions,
    values;
    color = "#1565C0",  # Dark blue
    width = 0.8
)

ax.xlabel = ""
ax.ylabel = "Proportion (%)"

ax.xgridvisible = false
ax.ygridvisible = false

# Set x-axis to fit bars exactly (no extra space)
xlims!(ax, 0.5, length(labels) + 0.5)

# Set y-axis so the max value is a bit higher than the tallest bar
max_value = maximum(values)
ylims!(ax, 0, max_value == 0 ? 1 : max_value * 1.05)

# Rotate x-axis labels diagonally
ax.xticklabelrotation = pi/4  # 45 degrees

fig

save("sector_tenders.png", fig)
