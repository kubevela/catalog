outputs: virtualservice: {
	apiVersion: "networking.istio.io/v1alpha3"
    kind: "VirtualService"
    metadata:
      name: context.nam
    spec:
      hosts:
      - "*"
      gateways: parameter.gateways
      http:
      - match:
        - uri:
            exact: /productpage
        - uri:
            prefix: /static
        - uri:
            exact: /login
        - uri:
            exact: /logout
        - uri:
            prefix: /api/v1/products
        route:
        - destination:
            host: productpage
            port:
              number: 9080
}
parameter: {
    gateways: [...string]
	ports?: [...{
		port: int
		name: string
	}]
}
