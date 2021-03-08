package controllers

import (
	"github.com/oam-dev/catalog/traits/autoscalertrait/api/v1alpha1"
)

// constants used in autoscaler controller
const (
	CronType v1alpha1.TriggerType = "cron"
	CPUType  v1alpha1.TriggerType = "cpu"
)
