parameter: {
	//+usage=Get BAIDUCLOUD_ACCESS_KEY per this guide https://github.com/oam-dev/terraform-controller/blob/2a98b2400ef1a00928b57965c40b37dc2914caf5/controllers/provider/baidu.go#L17
	BAIDUCLOUD_ACCESS_KEY: *"" | string
	//+usage=Get BAIDUCLOUD_SECRET_KEY per this guide https://github.com/oam-dev/terraform-controller/blob/2a98b2400ef1a00928b57965c40b37dc2914caf5/controllers/provider/baidu.go#L18
	BAIDUCLOUD_SECRET_KEY: *"" | string
	//+usage=Get BAIDUCLOUD_REGION by picking one RegionId from Baidu Cloud region list https://cloud.baidu.com/doc/Reference/s/2jwvz23xx
	BAIDUCLOUD_REGION: *"" | string
}
