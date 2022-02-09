parameter: {
	//+usage=Get gcpCredentialsJSON per this guide https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started#adding-credentials
	GOOGLE_CREDENTIALS: *"" | string
	//+usage=Get GOOGLE_REGION by picking one RegionId from Google Cloud region list https://cloud.google.com/compute/docs/regions-zones
	GOOGLE_REGION: *"" | string
	//+usage=Set gcpProject per this guide https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/getting_started#configuring-the-provider
	GOOGLE_PROJECT: *"" | string
}
