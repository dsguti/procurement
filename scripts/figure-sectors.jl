using DuckDB, DBInterface
using DataFramesMeta
using CairoMakie

con = DuckDB.DB("data/processed/purchases.duckdb")

res = DBInterface.execute(con, """
    SELECT 
    EXTRACT(year FROM fechacreacion) AS ano,
    sector,
    COUNT(*) AS cantidad
    FROM (
        SELECT DISTINCT id, sector, fechacreacion
        FROM raw
    ) sub
    GROUP BY ano, sector
    ORDER BY ano, cantidad DESC;
""") |> DataFrame

df1 = @rsubset(res, :sector == "Municipalidades")
df2 = @rsubset(res, :sector != "Municipalidades")
df2 = @by df2 :ano :cantidad = sum(:cantidad)

fig = Figure(size=(1000, 500))
ax = Axis(fig[1,1])

lines!(df1.ano, df1.cantidad, label = "Municipalities")
lines!(df2.ano, df2.cantidad, label = "Other")

axislegend(ax)

fig

save("figures/figure-sectors.svg", fig)