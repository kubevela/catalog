parameter: {
  // +usage=Specify the targetNamespace where the cert-manager component will apply
  "tgtNs": *"cert-manager"| string
  // +usage=Specify if install the CRDs before installing cert-manager or not
  "installCRDs": *true | bool
}
