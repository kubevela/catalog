package main

prism: {
	name: "vela-prism"
	type: "webservice"
	properties: {
		image:           parameter["image"]
		imagePullPolicy: parameter["imagePullPolicy"]
	}
	traits: [{
		type: "expose"
		properties: port: [9443]
	}, {
		type: "service-account"
		properties: {
			name:   "vela-prism"
			create: true
			privileges: [ for p in _clusterPrivileges {
				scope: "cluster"
				{p}
			}]
		}
	}, {
		type: "command"
		properties: command: [
			"vela-prism",
			"--secure-port=9443",
			"--feature-gates=APIPriorityAndFairness=false",
			"--cert-dir=/etc/k8s-apiserver-certs",
			"--storage-namespace=\(parameter.namespace)",
		]
	}, {
		type: "init-container"
		properties: {
			name:  "init-config"
			image: "oamdev/openssl-curl:0.1.0"
			cmd: ["sh", "-c", #"""
				cd /etc/k8s-apiserver-certs;
				echo "authorityKeyIdentifier=keyid,issuer
				basicConstraints=CA:FALSE
				subjectAltName = @alt_names
				[alt_names]
				DNS.1 = vela-prism
				DNS.2 = vela-prism.vela-system.svc" > domain.ext \
				&& openssl req -x509 -sha256 -days 3650 -newkey rsa:2048 -keyout ca.key -out ca -nodes -subj '/O=kubevela' \
				&& openssl ecparam -name prime256v1 -genkey -noout -out apiserver.key \
				&& openssl req -new -key apiserver.key -out apiserver.csr -subj '/O=vela-prism' \
				&& openssl x509 -req -in apiserver.csr -CA ca -CAkey ca.key -CAcreateserial -extfile domain.ext -out apiserver.crt -days 3650 -sha256 \
				&& echo "apiserver.crt" \
				&& cat apiserver.crt \
				&& export KUBE_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token) \
				&& export CA=$(cat ca | base64 | tr -d \\n) \
				&& echo "caBundle: $CA" \
				&& export PATCH_DATA='[{"op":"replace","path":"/spec/caBundle","value":"'$CA'"}]' \
				&& echo "patchData: $PATCH_DATA" \
				&& curl --request PATCH -sSk -H "Authorization: Bearer $KUBE_TOKEN" -H "Content-Type: application/json-patch+json" \
					https://kubernetes.default/apis/apiregistration.k8s.io/v1/apiservices/v1alpha1.prism.oam.dev \
					--data $PATCH_DATA \
				&& curl --request PATCH -sSk -H "Authorization: Bearer $KUBE_TOKEN" -H "Content-Type: application/json-patch+json" \
					https://kubernetes.default/apis/apiregistration.k8s.io/v1/apiservices/v1alpha1.o11y.prism.oam.dev \
					--data $PATCH_DATA
				"""#]
			mountName:     "k8s-apiserver-certs"
			appMountPath:  "/etc/k8s-apiserver-certs"
			initMountPath: "/etc/k8s-apiserver-certs"
		}
	}, {
		type: "resource"
		properties: {
			cpu:    parameter["cpu"]
			memory: parameter["memory"]
		}
	}]
}

_clusterPrivileges: [{
	apiGroups: [""]
	resources: ["namespaces"]
	verbs: ["get", "watch", "list"]
}, {
	apiGroups: ["core.oam.dev"]
	resources: ["resourcetrackers"]
	verbs: ["get", "watch", "list"]
}, {
	apiGroups: ["admissionregistration.k8s.io"]
	resources: ["mutatingwebhookconfigurations", "validatingwebhookconfigurations"]
	verbs: ["get", "list", "watch"]
}, {
	apiGroups: ["flowcontrol.apiserver.k8s.io"]
	resources: ["prioritylevelconfigurations", "flowschemas"]
	verbs: ["get", "list", "watch"]
}, {
	apiGroups: ["authorization.k8s.io"]
	resources: ["subjectaccessreviews"]
	verbs: ["*"]
}, {
	apiGroups: [""]
	resources: ["secrets"]
	verbs: ["get", "watch", "list", "create", "update", "delete", "patch"]
}, {
	apiGroups: ["cluster.open-cluster-management.io"]
	resources: ["managedclusters"]
	verbs: ["get", "watch", "list"]
}, {
	apiGroups: ["apiregistration.k8s.io"]
	resources: ["apiservices"]
	resourceNames: ["v1alpha1.prism.oam.dev", "v1alpha1.o11y.prism.oam.dev"]
	verbs: ["patch"]
}]
