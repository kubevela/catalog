info: string

if !parameter.pluginOnly {
	info: """
		By default, the backstage app is strictly serving in the domain `127.0.0.1:7007`, check it by:
		            
		    vela port-forward addon-backstage -n vela-system
		
		You can build your own backstage app if you want to use it in other domains. You can remove the backstage app and expose the service by:
		
		    vela addon enable backstage pluginOnly=true serviceType=NodePort
		
		Then you can run the backstage app in other place pointing the endpoint configured.
		"""
}
if parameter.pluginOnly {
	info: "You can use the endpoint of 'backstage-plugin-vela' in your own backstage app by configuring the 'vela.host', refer to example https://github.com/wonderflow/vela-backstage-demo."
}
notes: (info)
