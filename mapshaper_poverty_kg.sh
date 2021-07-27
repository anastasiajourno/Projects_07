curl -o kg_shp.zip https://biogeo.ucdavis.edu/data/gadm3.6/shp/gadm36_KGZ_shp.zip -L
unzip kg_shp.zip
mapshaper gadm36_KGZ_1.shp -join poverty_rate.csv keys=GID_1,KGZ -o merged.shp
mapshaper merged.shp -proj natearth -o proj.shp
mapshaper proj.shp -colorizer name=giveColor colors='#f0f9e8, #bae4bc, #7bccc4, #43a2ca, #0868ac', breaks=15,20,25,30 -style fill='giveColor(y2020)' -o demo.svg
mkdir svg png annotated
for ((year=2016;year<=2020;year++))
	do
	mapshaper proj.shp -colorizer name=giveColor colors='#f0f9e8,#bae4bc,#7bccc4,#2b8cbe,#08519c' breaks=15,20,25,30 -style fill='giveColor(y'${year}')' -o svg/${year}.svg
	done
-svgexport svg/${year}.svg png/${year}.png
for ((year=2016;year<=2020;year++))
	do
	convert svg/${year}.svg png/${year}.png
	done
for ((year=2016;year<=2020;year++))
	do
	magick convert png/${year}.png -background white -alpha remove -alpha off -gravity south -fill black -pointsize 24 -annotate +0+0 ${year} annotated/${year}.png
	done
magick convert -delay 50 *.png -loop 0  animate.gif 
magick convert animate.gif -coalesce \
          -gravity SouthEast -draw 'image over 0,0 0,0 "label.png"' \
          -gravity North -pointsize 20 -background white -splice 0x18 \
          -annotate 0 'A sad loop: in 2020 poverty rate in Kyrgyzstan went back to its 2016 level' \
          -layers Optimize  animate-label.gif