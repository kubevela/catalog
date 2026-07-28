parameter: {
	//+usage=Deploy a ValidatingAdmissionPolicy to every managed (spoke) cluster that blocks the
	// cluster-gateway ServiceAccount from minting its own ServiceAccount tokens
	includeAdmissionPolicy: *true | bool
}