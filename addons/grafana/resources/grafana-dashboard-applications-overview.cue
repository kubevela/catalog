package main

grafanaDashboardApplicationOverview: {
	name: "grafana-dashboard-application-overview"
	type: "grafana-dashboard"
	properties: {
		uid:     "application-overview"
		grafana: parameter.grafanaName
		data:    grafanaDashboardApplicationOverviewData
	}
}

grafanaDashboardApplicationOverviewData: #"""
	{
	  "description": "KubeVela Application Overview",
	  "editable": false,
	  "links": [{
	    "asDropdown": false,
	    "icon": "external link",
	    "includeVars": false,
	    "keepTime": true,
	    "tags": [
	      "kubevela",
	      "system"
	    ],
	    "targetBlank": true,
	    "title": "KubeVela System",
	    "tooltip": "",
	    "type": "dashboards",
	    "url": ""
	  }, {
	    "asDropdown": false,
	    "icon": "external link",
	    "includeVars": false,
	    "keepTime": true,
	    "tags": [
	      "kubernetes",
	      "system"
	    ],
	    "targetBlank": true,
	    "title": "Kubernetes System",
	    "tooltip": "",
	    "type": "dashboards",
	    "url": ""
	  }],
	  "panels": [
	    {
	      "gridPos": {
	        "h": 1,
	        "w": 24,
	        "x": 0,
	        "y": 0
	      },
	      "id": 25,
	      "title": "Basic Information",
	      "type": "row"
	    },
	    {
	      "datasource": {
	        "type": "marcusolsson-json-datasource",
	        "uid": "kubernetes-api"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "mode": "thresholds"
	          },
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "#5f5f5f",
	                "value": null
	              }
	            ]
	          }
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 12,
	        "x": 0,
	        "y": 1
	      },
	      "id": 12,
	      "options": {
	        "colorMode": "background",
	        "graphMode": "area",
	        "justifyMode": "auto",
	        "orientation": "auto",
	        "reduceOptions": {
	          "calcs": [
	            "lastNotNull"
	          ],
	          "fields": "/.*/",
	          "values": true
	        },
	        "text": {
	          "valueSize": 32
	        },
	        "textMode": "auto"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "cacheDurationSeconds": 300,
	          "datasource": {
	            "type": "marcusolsson-json-datasource",
	            "uid": "kubernetes-api"
	          },
	          "fields": [
	            {
	              "jsonPath": "$.metadata.name",
	              "language": "jsonata"
	            }
	          ],
	          "method": "GET",
	          "queryParams": "",
	          "refId": "A",
	          "urlPath": "/apis/core.oam.dev/v1beta1/namespaces/$namespace/applications/$application"
	        }
	      ],
	      "title": "Application",
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "marcusolsson-json-datasource",
	        "uid": "kubernetes-api"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "mode": "thresholds"
	          },
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "#5f5f5f",
	                "value": null
	              }
	            ]
	          },
	          "unit": "ms"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 3,
	        "x": 12,
	        "y": 1
	      },
	      "id": 15,
	      "options": {
	        "colorMode": "background",
	        "graphMode": "area",
	        "justifyMode": "auto",
	        "orientation": "auto",
	        "reduceOptions": {
	          "calcs": [
	            "lastNotNull"
	          ],
	          "fields": "/.*/",
	          "values": false
	        },
	        "text": {
	          "valueSize": 32
	        },
	        "textMode": "auto"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "cacheDurationSeconds": 300,
	          "datasource": {
	            "type": "marcusolsson-json-datasource",
	            "uid": "kubernetes-api"
	          },
	          "fields": [
	            {
	              "jsonPath": "$millis() - $toMillis($.metadata.creationTimestamp)",
	              "language": "jsonata",
	              "name": "CreateTime"
	            }
	          ],
	          "method": "GET",
	          "queryParams": "",
	          "refId": "A",
	          "urlPath": "/apis/core.oam.dev/v1beta1/namespaces/$namespace/applications/$application"
	        }
	      ],
	      "title": "Age",
	      "transformations": [],
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "marcusolsson-json-datasource",
	        "uid": "kubernetes-api"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "mode": "thresholds"
	          },
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "#5f5f5f",
	                "value": null
	              }
	            ]
	          }
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 3,
	        "x": 15,
	        "y": 1
	      },
	      "id": 22,
	      "options": {
	        "colorMode": "background",
	        "graphMode": "area",
	        "justifyMode": "auto",
	        "orientation": "auto",
	        "reduceOptions": {
	          "calcs": [
	            "lastNotNull"
	          ],
	          "fields": "/.*/",
	          "values": false
	        },
	        "text": {
	          "valueSize": 32
	        },
	        "textMode": "auto"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "cacheDurationSeconds": 300,
	          "datasource": {
	            "type": "marcusolsson-json-datasource",
	            "uid": "kubernetes-api"
	          },
	          "fields": [
	            {
	              "jsonPath": "$exists($.metadata.annotations.\"app.oam.dev/publishVersion\") ? $.metadata.annotations.\"app.oam.dev/publishVersion\" : 'NA'",
	              "language": "jsonata",
	              "name": "CreateTime"
	            }
	          ],
	          "method": "GET",
	          "queryParams": "",
	          "refId": "A",
	          "urlPath": "/apis/core.oam.dev/v1beta1/namespaces/$namespace/applications/$application"
	        }
	      ],
	      "title": "PublishVersion",
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "marcusolsson-json-datasource",
	        "uid": "kubernetes-api"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "mode": "thresholds"
	          },
	          "mappings": [
	            {
	              "options": {
	                "false": {
	                  "color": "purple",
	                  "index": 0,
	                  "text": "False"
	                },
	                "true": {
	                  "color": "blue",
	                  "index": 1,
	                  "text": "True"
	                }
	              },
	              "type": "value"
	            }
	          ],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "text",
	                "value": null
	              }
	            ]
	          },
	          "unit": "none"
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 3,
	        "x": 18,
	        "y": 1
	      },
	      "id": 27,
	      "options": {
	        "colorMode": "background",
	        "graphMode": "area",
	        "justifyMode": "auto",
	        "orientation": "auto",
	        "reduceOptions": {
	          "calcs": [
	            "lastNotNull"
	          ],
	          "fields": "/.*/",
	          "values": false
	        },
	        "text": {
	          "valueSize": 32
	        },
	        "textMode": "auto"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "cacheDurationSeconds": 300,
	          "datasource": {
	            "type": "marcusolsson-json-datasource",
	            "uid": "kubernetes-api"
	          },
	          "fields": [
	            {
	              "jsonPath": "$exists($.metadata.labels.\"addons.oam.dev/name\")",
	              "language": "jsonata",
	              "name": "CreateTime"
	            }
	          ],
	          "method": "GET",
	          "queryParams": "",
	          "refId": "A",
	          "urlPath": "/apis/core.oam.dev/v1beta1/namespaces/$namespace/applications/$application"
	        }
	      ],
	      "title": "Addon",
	      "transformations": [],
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "marcusolsson-json-datasource",
	        "uid": "kubernetes-api"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "mode": "thresholds"
	          },
	          "mappings": [
	            {
	              "options": {
	                "deleting": {
	                  "color": "purple",
	                  "index": 4,
	                  "text": "Deleting"
	                },
	                "rendering": {
	                  "color": "yellow",
	                  "index": 2,
	                  "text": "Rendering"
	                },
	                "running": {
	                  "color": "green",
	                  "index": 0,
	                  "text": "Running"
	                },
	                "runningWorkflow": {
	                  "color": "yellow",
	                  "index": 1,
	                  "text": "RunningWorkflow"
	                }
	              },
	              "type": "value"
	            }
	          ],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "#F2495C",
	                "value": null
	              }
	            ]
	          }
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 3,
	        "w": 3,
	        "x": 21,
	        "y": 1
	      },
	      "id": 16,
	      "options": {
	        "colorMode": "background",
	        "graphMode": "area",
	        "justifyMode": "auto",
	        "orientation": "auto",
	        "reduceOptions": {
	          "calcs": [
	            "lastNotNull"
	          ],
	          "fields": "/.*/",
	          "values": false
	        },
	        "text": {
	          "valueSize": 32
	        },
	        "textMode": "auto"
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "cacheDurationSeconds": 300,
	          "datasource": {
	            "type": "marcusolsson-json-datasource",
	            "uid": "kubernetes-api"
	          },
	          "fields": [
	            {
	              "jsonPath": "$.status.status",
	              "language": "jsonata",
	              "name": "CreateTime"
	            }
	          ],
	          "method": "GET",
	          "queryParams": "",
	          "refId": "A",
	          "urlPath": "/apis/core.oam.dev/v1beta1/namespaces/$namespace/applications/$application"
	        }
	      ],
	      "title": "Status",
	      "type": "stat"
	    },
	    {
	      "datasource": {
	        "type": "marcusolsson-json-datasource",
	        "uid": "kubernetes-api"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "mode": "thresholds"
	          },
	          "custom": {
	            "align": "auto",
	            "displayMode": "auto",
	            "inspect": false
	          },
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "green",
	                "value": null
	              },
	              {
	                "color": "red",
	                "value": 80
	              }
	            ]
	          }
	        },
	        "overrides": [
	          {
	            "matcher": {
	              "id": "byName",
	              "options": "Properties"
	            },
	            "properties": [
	              {
	                "id": "custom.displayMode",
	                "value": "json-view"
	              },
	              {
	                "id": "custom.inspect",
	                "value": true
	              }
	            ]
	          }
	        ]
	      },
	      "gridPos": {
	        "h": 5,
	        "w": 5,
	        "x": 0,
	        "y": 4
	      },
	      "id": 18,
	      "options": {
	        "footer": {
	          "fields": "",
	          "reducer": [
	            "sum"
	          ],
	          "show": false
	        },
	        "showHeader": true
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "cacheDurationSeconds": 300,
	          "datasource": {
	            "type": "marcusolsson-json-datasource",
	            "uid": "kubernetes-api"
	          },
	          "fields": [
	            {
	              "jsonPath": "$.spec.components[*].name",
	              "name": "Name"
	            },
	            {
	              "jsonPath": "$.spec.components[*].type",
	              "language": "jsonpath",
	              "name": "Type"
	            },
	            {
	              "jsonPath": "$.spec.components[*].($exists(properties) ? $string(properties) : '{}')",
	              "language": "jsonata",
	              "name": "Properties"
	            }
	          ],
	          "method": "GET",
	          "queryParams": "",
	          "refId": "A",
	          "urlPath": "/apis/core.oam.dev/v1beta1/namespaces/$namespace/applications/$application"
	        }
	      ],
	      "title": "Components",
	      "type": "table"
	    },
	    {
	      "datasource": {
	        "type": "marcusolsson-json-datasource",
	        "uid": "kubernetes-api"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "mode": "thresholds"
	          },
	          "custom": {
	            "align": "auto",
	            "displayMode": "auto",
	            "inspect": false
	          },
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "green",
	                "value": null
	              },
	              {
	                "color": "red",
	                "value": 80
	              }
	            ]
	          }
	        },
	        "overrides": [
	          {
	            "matcher": {
	              "id": "byName",
	              "options": "Properties"
	            },
	            "properties": [
	              {
	                "id": "custom.displayMode",
	                "value": "json-view"
	              },
	              {
	                "id": "custom.inspect",
	                "value": true
	              }
	            ]
	          }
	        ]
	      },
	      "gridPos": {
	        "h": 5,
	        "w": 5,
	        "x": 5,
	        "y": 4
	      },
	      "id": 19,
	      "options": {
	        "footer": {
	          "fields": "",
	          "reducer": [
	            "sum"
	          ],
	          "show": false
	        },
	        "showHeader": true
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "cacheDurationSeconds": 300,
	          "datasource": {
	            "type": "marcusolsson-json-datasource",
	            "uid": "kubernetes-api"
	          },
	          "fields": [
	            {
	              "jsonPath": "$.spec.policies[*].name",
	              "name": "Name"
	            },
	            {
	              "jsonPath": "$.spec.policies[*].type",
	              "language": "jsonpath",
	              "name": "Type"
	            },
	            {
	              "jsonPath": "$.spec.policies[*].($exists(properties) ? $string(properties) : '{}')",
	              "language": "jsonata",
	              "name": "Properties"
	            }
	          ],
	          "method": "GET",
	          "queryParams": "",
	          "refId": "A",
	          "urlPath": "/apis/core.oam.dev/v1beta1/namespaces/$namespace/applications/$application"
	        }
	      ],
	      "title": "Policies",
	      "type": "table"
	    },
	    {
	      "datasource": {
	        "type": "marcusolsson-json-datasource",
	        "uid": "kubernetes-api"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "mode": "thresholds"
	          },
	          "custom": {
	            "align": "auto",
	            "displayMode": "auto",
	            "inspect": false
	          },
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "green",
	                "value": null
	              },
	              {
	                "color": "red",
	                "value": 80
	              }
	            ]
	          }
	        },
	        "overrides": [
	          {
	            "matcher": {
	              "id": "byName",
	              "options": "Properties"
	            },
	            "properties": [
	              {
	                "id": "custom.displayMode",
	                "value": "json-view"
	              },
	              {
	                "id": "custom.inspect",
	                "value": true
	              }
	            ]
	          }
	        ]
	      },
	      "gridPos": {
	        "h": 5,
	        "w": 5,
	        "x": 10,
	        "y": 4
	      },
	      "id": 20,
	      "options": {
	        "footer": {
	          "fields": "",
	          "reducer": [
	            "sum"
	          ],
	          "show": false
	        },
	        "showHeader": true
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "cacheDurationSeconds": 300,
	          "datasource": {
	            "type": "marcusolsson-json-datasource",
	            "uid": "kubernetes-api"
	          },
	          "fields": [
	            {
	              "jsonPath": "$.spec.workflow.steps[*].name",
	              "name": "Name"
	            },
	            {
	              "jsonPath": "$.spec.workflow.steps[*].type",
	              "language": "jsonpath",
	              "name": "Type"
	            },
	            {
	              "jsonPath": "$.spec.workflow.steps[*].($exists(properties) ? $string(properties) : '{}')",
	              "language": "jsonata",
	              "name": "Properties"
	            }
	          ],
	          "method": "GET",
	          "queryParams": "",
	          "refId": "A",
	          "urlPath": "/apis/core.oam.dev/v1beta1/namespaces/$namespace/applications/$application"
	        }
	      ],
	      "title": "WorkflowSteps",
	      "type": "table"
	    },
	    {
	      "datasource": {
	        "type": "marcusolsson-json-datasource",
	        "uid": "kubernetes-api"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "mode": "thresholds"
	          },
	          "custom": {
	            "align": "left",
	            "displayMode": "color-text",
	            "filterable": false,
	            "inspect": false
	          },
	          "mappings": [
	            {
	              "options": {
	                "succeeded": {
	                  "color": "green",
	                  "index": 0
	                }
	              },
	              "type": "value"
	            }
	          ],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "text",
	                "value": null
	              }
	            ]
	          }
	        },
	        "overrides": []
	      },
	      "gridPos": {
	        "h": 5,
	        "w": 9,
	        "x": 15,
	        "y": 4
	      },
	      "id": 21,
	      "options": {
	        "footer": {
	          "enablePagination": false,
	          "fields": "",
	          "reducer": [
	            "sum"
	          ],
	          "show": false
	        },
	        "showHeader": true
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "cacheDurationSeconds": 300,
	          "datasource": {
	            "type": "marcusolsson-json-datasource",
	            "uid": "kubernetes-api"
	          },
	          "fields": [
	            {
	              "jsonPath": "$.status.workflow.steps[*].id"
	            },
	            {
	              "jsonPath": "$.status.workflow.steps[*].name",
	              "language": "jsonpath",
	              "name": ""
	            },
	            {
	              "jsonPath": "$.status.workflow.steps[*].type",
	              "language": "jsonpath",
	              "name": ""
	            },
	            {
	              "jsonPath": "$.status.workflow.steps[*].firstExecuteTime",
	              "language": "jsonpath",
	              "name": ""
	            },
	            {
	              "jsonPath": "$.status.workflow.steps[*].lastExecuteTime",
	              "language": "jsonpath",
	              "name": ""
	            },
	            {
	              "jsonPath": "$.status.workflow.steps[*].phase",
	              "language": "jsonpath",
	              "name": ""
	            }
	          ],
	          "method": "GET",
	          "queryParams": "",
	          "refId": "A",
	          "urlPath": "/apis/core.oam.dev/v1beta1/namespaces/$namespace/applications/$application"
	        }
	      ],
	      "title": "WorkflowStep Status",
	      "transformations": [],
	      "type": "table"
	    },
	    {
	      "collapsed": false,
	      "gridPos": {
	        "h": 1,
	        "w": 24,
	        "x": 0,
	        "y": 9
	      },
	      "id": 8,
	      "panels": [],
	      "title": "Related Resources",
	      "type": "row"
	    },
	    {
	      "datasource": {
	        "type": "marcusolsson-json-datasource",
	        "uid": "kubernetes-api"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "mode": "thresholds"
	          },
	          "custom": {
	            "align": "auto",
	            "displayMode": "color-text",
	            "inspect": false
	          },
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "text",
	                "value": null
	              }
	            ]
	          }
	        },
	        "overrides": [
	          {
	            "matcher": {
	              "id": "byName",
	              "options": "Dashboard"
	            },
	            "properties": [
	              {
	                "id": "links",
	                "value": [
	                  {
	                    "targetBlank": true,
	                    "title": "Details",
	                    "url": "/d/${__data.fields.DashboardID}${__data.fields.URLParams}"
	                  }
	                ]
	              },
	              {
	                "id": "custom.width",
	                "value": 100
	              },
	              {
	                "id": "mappings",
	                "value": [
	                  {
	                    "options": {
	                      "pattern": ".+",
	                      "result": {
	                        "color": "blue",
	                        "index": 0
	                      }
	                    },
	                    "type": "regex"
	                  }
	                ]
	              },
	              {
	                "id": "custom.align",
	                "value": "auto"
	              }
	            ]
	          },
	          {
	            "matcher": {
	              "id": "byRegexp",
	              "options": "URLParams|DashboardID|APIVersion"
	            },
	            "properties": [
	              {
	                "id": "custom.hidden",
	                "value": true
	              }
	            ]
	          },
	          {
	            "matcher": {
	              "id": "byName",
	              "options": "Cluster"
	            },
	            "properties": [
	              {
	                "id": "custom.width",
	                "value": 80
	              }
	            ]
	          },
	          {
	            "matcher": {
	              "id": "byName",
	              "options": "Namespace"
	            },
	            "properties": [
	              {
	                "id": "custom.width",
	                "value": 120
	              }
	            ]
	          },
	          {
	            "matcher": {
	              "id": "byName",
	              "options": "Kind"
	            },
	            "properties": [
	              {
	                "id": "custom.width",
	                "value": 140
	              }
	            ]
	          }
	        ]
	      },
	      "gridPos": {
	        "h": 14,
	        "w": 12,
	        "x": 0,
	        "y": 10
	      },
	      "id": 4,
	      "options": {
	        "footer": {
	          "fields": "",
	          "reducer": [
	            "sum"
	          ],
	          "show": false
	        },
	        "showHeader": true,
	        "sortBy": [
	          {
	            "desc": false,
	            "displayName": "Cluster"
	          }
	        ]
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "cacheDurationSeconds": 300,
	          "datasource": {
	            "type": "marcusolsson-json-datasource",
	            "uid": "kubernetes-api"
	          },
	          "fields": [
	            {
	              "jsonPath": "$.status.appliedResources[*].(cluster ? cluster : 'local')",
	              "language": "jsonata",
	              "name": "Cluster"
	            },
	            {
	              "jsonPath": "$.status.appliedResources[*].(namespace ? namespace : '-')",
	              "language": "jsonata",
	              "name": "Namespace"
	            },
	            {
	              "jsonPath": "$.status.appliedResources[*].apiVersion",
	              "language": "jsonata",
	              "name": "APIVersion"
	            },
	            {
	              "jsonPath": "$.status.appliedResources[*].kind",
	              "language": "jsonata",
	              "name": "Kind"
	            },
	            {
	              "jsonPath": "$.status.appliedResources[*].name",
	              "language": "jsonata",
	              "name": "Name"
	            },
	            {
	              "jsonPath": "$.status.appliedResources[*].((kind = 'Deployment' or kind = 'StatefulSet' or kind = 'DaemonSet' or kind = 'Pod' or kind = 'GrafanaDashboard') ? 'Details' : '')",
	              "language": "jsonata",
	              "name": " Link"
	            },
	            {
	              "jsonPath": "$.status.appliedResources[*].(kind = 'GrafanaDashboard' ? '' : ('?var-cluster=' & (cluster ? cluster : 'local') & '&var-namespace=' & (namespace ? namespace : '-') & '&var-name=' & name))",
	              "language": "jsonata",
	              "name": "URLParams"
	            },
	            {
	              "jsonPath": "$.status.appliedResources[*].((kind = 'Deployment' or kind = 'StatefulSet' or kind = 'DaemonSet' or kind = 'Pod') ? ('kubernetes-' & $lowercase(kind) & '/kubernetes-' & $lowercase(kind)) : (kind = 'GrafanaDashboard' ? $split(name, '@')[0] : ''))",
	              "language": "jsonata",
	              "name": "DashboardID"
	            }
	          ],
	          "method": "GET",
	          "queryParams": "",
	          "refId": "A",
	          "urlPath": "/apis/core.oam.dev/v1beta1/namespaces/$namespace/applications/$application"
	        }
	      ],
	      "title": "Managed Resources",
	      "transformations": [
	        {
	          "id": "organize",
	          "options": {
	            "excludeByName": {},
	            "indexByName": {
	              " Link": 0,
	              "APIVersion": 3,
	              "Cluster": 5,
	              "DashboardID": 7,
	              "Kind": 4,
	              "Name": 1,
	              "Namespace": 2,
	              "URLParams": 6
	            },
	            "renameByName": {
	              " Link": "Dashboard"
	            }
	          }
	        }
	      ],
	      "type": "table"
	    },
	    {
	      "datasource": {
	        "type": "marcusolsson-json-datasource",
	        "uid": "kubernetes-api"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "mode": "thresholds"
	          },
	          "custom": {
	            "align": "left",
	            "displayMode": "auto",
	            "inspect": false
	          },
	          "mappings": [],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "green",
	                "value": null
	              },
	              {
	                "color": "red",
	                "value": 80
	              }
	            ]
	          }
	        },
	        "overrides": [
	          {
	            "matcher": {
	              "id": "byName",
	              "options": "Json"
	            },
	            "properties": [
	              {
	                "id": "custom.displayMode",
	                "value": "json-view"
	              },
	              {
	                "id": "custom.inspect",
	                "value": true
	              }
	            ]
	          }
	        ]
	      },
	      "gridPos": {
	        "h": 7,
	        "w": 12,
	        "x": 12,
	        "y": 10
	      },
	      "id": 9,
	      "options": {
	        "footer": {
	          "fields": "",
	          "reducer": [
	            "sum"
	          ],
	          "show": false
	        },
	        "showHeader": true,
	        "sortBy": [
	          {
	            "desc": true,
	            "displayName": "Cluster"
	          }
	        ]
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "cacheDurationSeconds": 300,
	          "datasource": {
	            "type": "marcusolsson-json-datasource",
	            "uid": "kubernetes-api"
	          },
	          "fields": [
	            {
	              "jsonPath": "$.items[*].metadata.name",
	              "language": "jsonpath",
	              "name": "Name"
	            },
	            {
	              "jsonPath": "$.items[*].spec.type",
	              "language": "jsonpath",
	              "name": "Type"
	            },
	            {
	              "jsonPath": "$.items[*].spec.applicationGeneration",
	              "language": "jsonpath",
	              "name": "Application Generation"
	            },
	            {
	              "jsonPath": "$.items[*].spec.($count(managedResources))",
	              "language": "jsonata",
	              "name": "#Resources"
	            },
	            {
	              "jsonPath": "$.items[*]",
	              "language": "jsonpath",
	              "name": "Json"
	            }
	          ],
	          "method": "GET",
	          "queryParams": "",
	          "refId": "A",
	          "urlPath": "/apis/core.oam.dev/v1beta1/resourcetrackers?labelSelector=app.oam.dev%2Fname%3D$application,app.oam.dev%2Fnamespace%3D$namespace"
	        }
	      ],
	      "title": "ResourceTrackers",
	      "type": "table"
	    },
	    {
	      "datasource": {
	        "type": "marcusolsson-json-datasource",
	        "uid": "kubernetes-api"
	      },
	      "fieldConfig": {
	        "defaults": {
	          "color": {
	            "mode": "thresholds"
	          },
	          "custom": {
	            "align": "auto",
	            "displayMode": "color-text",
	            "inspect": false
	          },
	          "mappings": [
	            {
	              "options": {
	                "true": {
	                  "color": "green",
	                  "index": 0
	                }
	              },
	              "type": "value"
	            }
	          ],
	          "thresholds": {
	            "mode": "absolute",
	            "steps": [
	              {
	                "color": "text",
	                "value": null
	              }
	            ]
	          }
	        },
	        "overrides": [
	          {
	            "matcher": {
	              "id": "byName",
	              "options": "Json"
	            },
	            "properties": [
	              {
	                "id": "custom.displayMode",
	                "value": "json-view"
	              },
	              {
	                "id": "custom.inspect",
	                "value": true
	              }
	            ]
	          }
	        ]
	      },
	      "gridPos": {
	        "h": 7,
	        "w": 12,
	        "x": 12,
	        "y": 17
	      },
	      "id": 10,
	      "options": {
	        "footer": {
	          "fields": "",
	          "reducer": [
	            "sum"
	          ],
	          "show": false
	        },
	        "showHeader": true,
	        "sortBy": [
	          {
	            "desc": true,
	            "displayName": "Cluster"
	          }
	        ]
	      },
	      "pluginVersion": "8.5.3",
	      "targets": [
	        {
	          "cacheDurationSeconds": 300,
	          "datasource": {
	            "type": "marcusolsson-json-datasource",
	            "uid": "kubernetes-api"
	          },
	          "fields": [
	            {
	              "jsonPath": "$.items[*].metadata.name",
	              "language": "jsonpath",
	              "name": "Name"
	            },
	            {
	              "jsonPath": "$.items[*].metadata.creationTimestamp",
	              "language": "jsonpath",
	              "name": "CreateTime"
	            },
	            {
	              "jsonPath": "$.items[*].status.succeeded",
	              "language": "jsonpath",
	              "name": "Succeeded"
	            },
	            {
	              "jsonPath": "$.items[*]",
	              "language": "jsonpath",
	              "name": "Json"
	            }
	          ],
	          "method": "GET",
	          "queryParams": "",
	          "refId": "A",
	          "urlPath": "/apis/core.oam.dev/v1beta1/namespaces/$namespace/applicationrevisions?labelSelector=app.oam.dev%2Fname%3D$application"
	        }
	      ],
	      "title": "ApplicationRevisions",
	      "type": "table"
	    },
	    {
	      "collapsed": true,
	      "gridPos": {
	        "h": 1,
	        "w": 24,
	        "x": 0,
	        "y": 24
	      },
	      "id": 6,
	      "panels": [
	        {
	          "datasource": {
	            "type": "marcusolsson-json-datasource",
	            "uid": "kubernetes-api"
	          },
	          "fieldConfig": {
	            "defaults": {
	              "color": {
	                "mode": "thresholds"
	              },
	              "custom": {
	                "align": "left",
	                "displayMode": "color-text",
	                "inspect": false
	              },
	              "mappings": [
	                {
	                  "options": {
	                    "running": {
	                      "color": "green",
	                      "index": 0
	                    }
	                  },
	                  "type": "value"
	                }
	              ],
	              "thresholds": {
	                "mode": "absolute",
	                "steps": [
	                  {
	                    "color": "text"
	                  }
	                ]
	              }
	            },
	            "overrides": [
	              {
	                "matcher": {
	                  "id": "byName",
	                  "options": "Json"
	                },
	                "properties": [
	                  {
	                    "id": "custom.displayMode",
	                    "value": "json-view"
	                  },
	                  {
	                    "id": "custom.inspect",
	                    "value": true
	                  }
	                ]
	              }
	            ]
	          },
	          "gridPos": {
	            "h": 7,
	            "w": 24,
	            "x": 0,
	            "y": 25
	          },
	          "id": 2,
	          "options": {
	            "footer": {
	              "fields": "",
	              "reducer": [
	                "sum"
	              ],
	              "show": false
	            },
	            "showHeader": true
	          },
	          "pluginVersion": "8.5.3",
	          "targets": [
	            {
	              "cacheDurationSeconds": 300,
	              "datasource": {
	                "type": "marcusolsson-json-datasource",
	                "uid": "kubernetes-api"
	              },
	              "fields": [
	                {
	                  "jsonPath": "$.items[*].metadata.namespace",
	                  "language": "jsonata",
	                  "name": "Namespace"
	                },
	                {
	                  "jsonPath": "$.items[*].metadata.name",
	                  "language": "jsonata",
	                  "name": "Name"
	                },
	                {
	                  "jsonPath": "$.items[*].metadata.creationTimestamp",
	                  "language": "jsonpath",
	                  "name": "CreateTime"
	                },
	                {
	                  "jsonPath": "$.items[*].spec.($count(components))",
	                  "language": "jsonata",
	                  "name": "#Components"
	                },
	                {
	                  "jsonPath": "$.items[*].spec.($count(policies))",
	                  "language": "jsonata",
	                  "name": "#Policies"
	                },
	                {
	                  "jsonPath": "$.items[*].status.workflow.mode",
	                  "language": "jsonata",
	                  "name": "WorkflowMode"
	                },
	                {
	                  "jsonPath": "$.items[*].status.workflow.($count(steps))",
	                  "language": "jsonata",
	                  "name": "#WorkflowSteps"
	                },
	                {
	                  "jsonPath": "$.items[*].status.status",
	                  "language": "jsonata",
	                  "name": "Status"
	                },
	                {
	                  "jsonPath": "$.items[*]",
	                  "language": "jsonpath",
	                  "name": "Json"
	                }
	              ],
	              "method": "GET",
	              "queryParams": "",
	              "refId": "A",
	              "urlPath": "/apis/core.oam.dev/v1beta1/namespaces/$namespace/applications"
	            }
	          ],
	          "title": "Application Overview",
	          "type": "table"
	        }
	      ],
	      "title": "Namespace($namespace) Overview",
	      "type": "row"
	    }
	  ],
	  "style": "dark",
	  "tags": [
	    "kubevela",
	    "application"
	  ],
	  "templating": {
	    "list": [
	      {
	        "current": {
	          "selected": false,
	          "text": "vela-system",
	          "value": "vela-system"
	        },
	        "datasource": {
	          "type": "marcusolsson-json-datasource",
	          "uid": "kubernetes-api"
	        },
	        "definition": "$.items[*].metadata.namespace",
	        "hide": 0,
	        "includeAll": false,
	        "multi": false,
	        "name": "namespace",
	        "options": [],
	        "query": {
	          "cacheDurationSeconds": 300,
	          "fields": [
	            {
	              "jsonPath": "$.items[*].metadata.namespace"
	            }
	          ],
	          "method": "GET",
	          "queryParams": "",
	          "urlPath": "/apis/core.oam.dev/v1beta1/applications"
	        },
	        "refresh": 1,
	        "regex": "",
	        "skipUrlSync": false,
	        "sort": 1,
	        "type": "query"
	      },
	      {
	        "current": {
	          "selected": false,
	          "text": "addon-grafana",
	          "value": "addon-grafana"
	        },
	        "datasource": {
	          "type": "marcusolsson-json-datasource",
	          "uid": "kubernetes-api"
	        },
	        "definition": "$.items[*].metadata.name",
	        "hide": 0,
	        "includeAll": false,
	        "multi": false,
	        "name": "application",
	        "options": [],
	        "query": {
	          "cacheDurationSeconds": 0,
	          "fields": [
	            {
	              "jsonPath": "$.items[*].metadata.name",
	              "language": "jsonata"
	            }
	          ],
	          "method": "GET",
	          "queryParams": "",
	          "urlPath": "/apis/core.oam.dev/v1beta1/namespaces/$namespace/applications"
	        },
	        "refresh": 2,
	        "regex": "",
	        "skipUrlSync": false,
	        "sort": 0,
	        "type": "query"
	      }
	    ]
	  },
	  "time": {
	    "from": "now-30m",
	    "to": "now"
	  },
	  "title": "KubeVela Applications",
	  "uid": "application-overview"
	}
	"""#
