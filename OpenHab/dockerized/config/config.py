f_config = open('myconfig.cfg','r')
f_items = open('../configurations/items/hpcc.items','w')
f_sitemaps = open('../configurations/sitemaps/hpcc.sitemap','w')

line = f_config.readline()
items = ''
sitemaps = 'sitemap default label=\"HPCC Center\" \n' + \
			'{\n' +\
			'Frame label=\"Working Room\"\n' +\
				'{\n'
icon=''
symbol=''

while  line!='':
	kind,name,numbers = line.split()

	if(kind == "Switch"):
		sitemap_kind = "Switch"
	elif(kind == "Number"):
		sitemap_kind = "Text"

	if(name =='Temperature'):
		icon= "<temperature>"
		symbol = " [%.1f C]"
	elif(name == 'Humility'):
		icon= "temperature"
		symbol= " [%.1f %%]"

	for i in range(0,int(numbers)):
		item_name = name + str(i)
		item_line=kind + ' ' + item_name + ' ' + '\"' + item_name + symbol + '\"' + ' ' + icon + ' ' + \
				'{ mqtt=\"<[mymosquitto:/Hpcc/' + item_name + ':state:default]\" }'
		items += item_line + "\n"


		sitemap_line= sitemap_kind + ' ' + "item=" + item_name + "\n"
		sitemaps += sitemap_line


	line=f_config.readline()
sitemaps += "}\n}"

f_items.write(items)
f_sitemaps.write(sitemaps)


f_config.close()
f_items.close()
f_sitemaps.close()

print ("Well Done !")

