// main.go
package main

import (
	"context"
	"flag"
	"log"
	"os"
	"os/signal"
	"syscall"

	"github.com/operator-framework/operator-sdk/pkg/k8sutil"
	"github.com/operator-framework/operator-sdk/pkg/leader"
	"github.com/operator-framework/operator-sdk/pkg/leader/manager"
	"github.com/operator-framework/operator-sdk/pkg/metrics"
	"github.com/operator-framework/operator-sdk/pkg/restmapper"
	"github.com/operator-framework/operator-sdk/pkg/util"
	corev1 "k8s.io/api/core/v1"
	"k8s.io/apimachinery/pkg/api/errors"
	"k8s.io/apimachinery/pkg/runtime"
	"k8s.io/apimachinery/pkg/runtime/schema"
	"k8s.io/client-go/dynamic"
	"k8s.io/client-go/kubernetes/scheme"
	"k8s.io/client-go/tools/clientcmd"
	"sigs.k8s.io/controller-runtime/pkg/client/config"
)

var (
	metricsAddr         string
	configFile          string
	watchNamespace      string
	leaderElection      bool
	leaderElectionID    string
	leaderElectionImage string
)

func init() {
	flag.StringVar(&metricsAddr, "metrics-addr", ":8080", "The address the metric endpoint binds to.")
	flag.StringVar(&configFile, "config", "", "The path to the config file.")
	flag.StringVar(&watchNamespace, "namespace", "", "The namespace to watch for changes. If unspecified, watch all namespaces.")
	flag.BoolVar(&leaderElection, "leader-election", false, "Enable leader election for controller manager. "+
		"Enabling this will ensure there is only one active controller manager.")
	flag.StringVar(&leaderElectionID, "leader-election-id", "", "The name of the configmap that is used for holding the leader lock.")
	flag.StringVar(&leaderElectionImage, "leader-election-image", "", "The image to use for the leader election sidecar container.")
	flag.Parse()
}

func main() {
	// Set up signals so we handle the first shutdown signal gracefully
	stopCh := util.SetupSignalHandler()

	// Create a new operator config
	operatorConfig := config.New()

	// Set up a dynamic client
	dynamicClient, err := dynamic.NewForConfig(operatorConfig)
	if err != nil {
		log.Fatalf("Failed to create dynamic client: %v", err)
	}

	// Set up a mapper to map resources
	mapper, err := restmapper.NewDynamicRESTMapper(operatorConfig)
	if err != nil {
		log.Fatalf("Failed to create REST mapper: %v", err)
	}

	// Set up scheme
	scheme := runtime.NewScheme()
	_ = scheme.AddToScheme(scheme.Scheme)

	// Create a new controller manager
	controllerManager, err := manager.New(manager.Options{
		MapperProvider: func(_ *restmapper.Config) (restmapper.Mapper, error) {
			return mapper, nil
		},
		Scheme:              scheme,
		MetricsBindAddress:  metricsAddr,
		LeaderElection:      leaderElection,
		LeaderElectionID:    leaderElectionID,
		LeaderElectionImage: leaderElectionImage,
	})
	if err != nil {
		log.Fatalf("Failed to create controller manager: %v", err)
	}

	// Add the controller to the manager
	if err := (&GamingSessionReconciler{
		Client:        controllerManager.GetClient(),
		DynamicClient: dynamicClient,
		Log:           logf.Log.WithName("controller").WithName("GamingSession"),
		Scheme:        scheme,
	}).SetupWithManager(controllerManager); err != nil {
		log.Fatalf("Failed to set up controller: %v", err)
	}

	// Set up the operator's leader election
	if leaderElection {
		// Create a new context
		ctx := context.TODO()

		// Create a new cancel function
		ctx, cancel := context.WithCancel(ctx)
		defer cancel()

		// Run the leader election
		go func() {
			if err := controllerManager.Start(ctx); err != nil {
				log.Fatalf("Failed to run controller manager: %v", err)
			}
		}()

		// Wait for a shutdown signal
		signalCh := make(chan os.Signal, 1)
		signal.Notify(signalCh, syscall.SIGINT, syscall.SIGTERM)
		<-signalCh
	} else {
		// Run the controller manager without leader election
		if err := controllerManager.Start(stopCh); err != nil {
			log.Fatalf("Failed to run controller manager: %v", err)
		}
	}
}

// GamingSessionReconciler reconciles a GamingSession object
type GamingSessionReconciler struct {
	client.Client
	Log           logr.Logger
	Scheme        *runtime.Scheme
	DynamicClient dynamic.Interface
}

// +kubebuilder:rbac:groups=apps,resources=pods,verbs=get;list;watch;create;update;patch;delete
// +kubebuilder:rbac:groups=apps,resources=pods/status,verbs=get;update;patch

func (r *GamingSessionReconciler) Reconcile(req ctrl.Request) (ctrl.Result, error) {
	_ = context.Background()
	_ = r.Log.WithValues("gamingsession", req.NamespacedName)

	// Fetch the GamingSession resource
	gamingSession := &v1alpha1.GamingSession{}
	err := r.Get(ctx, req.NamespacedName, gamingSession)
	if err != nil {
		if errors.IsNotFound(err) {
			// GamingSession not found, no need to reconcile
			return ctrl.Result{}, nil
		}
		// Error fetching the GamingSession resource, requeue the request
		return ctrl.Result{}, err
	}

	// Logic to manage gaming sessions according to the requirements

	return ctrl.Result{}, nil
}

func (r *GamingSessionReconciler) SetupWithManager(mgr ctrl.Manager) error {
	return ctrl.NewControllerManagedBy(mgr).
		For(&v1alpha1.GamingSession{}).
		Owns(&corev1.Pod{}).
		Complete(r)
}
