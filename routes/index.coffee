
#
# * GET home page.
# 
#Temporary until DB is set up

forms = [
	{
		title: "Children's Hospital Hearing Form"
		place: "Children's Hospital",
		location: 'Vancouver',
		type: 'Audiology',
		body: 'sample 1'
	},
	{
		title: "KMC Austism Form",
		place: "KMC",
		location: 'Burnaby',
		type: 'Autism Screening',
		body: 'sample 2'
	}
]

exports.index = (req, res) ->
 	res.render "layout",
    	title: "Form Search"

exports.results = (req, res) ->

	res.contentType "json" 
	result = forms.map((p) ->
		if p != p.body
			p
	)
	res.json(result)

