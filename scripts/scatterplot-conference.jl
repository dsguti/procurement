using QuackIO
using DataFramesMeta
using CairoMakie
using AlgebraOfGraphics
using XLSX

dat = QuackIO.read_parquet(DataFrame, "data/intermediate/communes-counts.parquet")
com = XLSX.readtable("data/intermediate/Tabla_Comparativo_Comuna.xlsx", "Población") |> DataFrame
com = select(com, :COMUNA => "commune", 7 => "population")

zones = [
 "Región de Tarapacá" => "North",
 "Región de Antofagasta" => "North",
 "Región de Arica y Parinacota" => "North",
 "Región de Atacama" => "North",
 "Región de Coquimbo" => "North",
 "Región de Valparaíso" => "Central",
 "Región del Biobío" => "Central",
 "Región del Libertador General Bernardo O´Higgins" => "Central",
 "Región del Maule" => "Central",
 "Región del Ñuble" => "Central",
 "Región Aysén del General Carlos Ibáñez del Campo" => "South",
 "Región Metropolitana de Santiago" => "Central",
 "Región de Los Ríos" => "South",
 "Región de Magallanes y de la Antártica" => "South",
 "Región de la Araucanía" => "South",
 "Región de los Lagos" => "South",
]

dat = @chain dat begin
    @rsubset !ismissing(:commune)
    @rsubset startswith(:commune, r"^[A-Za-z]")
    @rsubset :sector == "Municipalidades"
    @rtransform :region = replace(string(strip(:region)), zones...)
    innerjoin(com, on=:commune)
    @rtransform :n_per_cap = (:n / :population)
    @rtransform :share_local = (:n_local / :n) * 100
end

# Faceted plot by region
spec = data(dat) * mapping(
    :n_per_cap => "Transactions per capita",
    :share_local => "Share Local",
    color = :region => "",
    row = :region => ""
) * (visual(Scatter, alpha=0.7) + smooth(span=0.95))

fig = draw(
    spec;
    legend = (; position = :bottom, drawlegend = false),
    axis = (; xtickformat = "{:,.0f}", limits = (-0, 10, -1, nothing)),
    figure = (; size = (400, 1000))
)

save("figures/denise-scatterplot.svg", fig)

# Plot without grouping by region (all data together, default color)
spec_all = data(dat) * mapping(
    :n_per_cap => "Transactions per capita",
    :share_local => "Share Local",
) * (visual(Scatter, alpha=0.7) + smooth(span=0.95))

fig_all = draw(
    spec_all;
    axis = (; xtickformat = "{:,.0f}", limits = (-0, 10, -1, nothing)),
    figure = (; size = (400, 400))
)

save("figures/denise-scatterplot-all.svg", fig_all)