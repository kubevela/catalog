package main

controllerArgs: [
	"--watch-all-namespaces",
	"--log-level=debug",
	"--log-encoding=json",
	// Turn off leader-election, otherwise user cannot upgrade from previous versions.
	//
	// Reason:
	//     Atfer we upgrade fluxcd from 1.3.5 to 2.0.0, new deployment/pods are created,
	//     they will wait for the leader to step down before they are ready.
	//
	//     Since the new pods are waiting, they are not ready. The controller will not 
    //     gc the leader.
	//
	//     So the new pods will keep waiting for the previous leader to step down,
	//     but the previous leader will not step down (being gc'ed) 
    //     because the new pods are not ready.
	//
	//     This is a deadlock.
	//
	// "--enable-leader-election",
]
