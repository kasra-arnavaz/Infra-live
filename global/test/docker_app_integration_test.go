package test

import (
	"fmt"
	"strings"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

const dbDir = "../../stage/data-stores/mysql"
const appDir = "../../stage/services/docker-app"
const bucketForTesting = "kasraz-test-state"
const bucketRegionForTesting = "us-east-2"

func TestDockerApp(t *testing.T) {
	t.Parallel()

	// Deploy the MySQL DB
	dbOpts := createDbOpts(t, dbDir)
	defer terraform.Destroy(t, dbOpts)
	terraform.InitAndApply(t, dbOpts)

	// Deploy the docker-app
	dockerOpts := createDockerOpts(t, dbOpts, appDir)
	defer terraform.Destroy(t, dockerOpts)
	terraform.InitAndApply(t, dockerOpts)

	// Validate that the docker-app works
	validateDockerApp(t, dockerOpts)
}

func createDbOpts(t *testing.T, terraformDir string) *terraform.Options {
	dbStateKey := fmt.Sprintf("%s/%s/terraform.tfstate", t.Name(), random.UniqueId())

	return &terraform.Options{
		TerraformDir: terraformDir,
		Vars: map[string]interface{}{
			"name":        "test",
			"db_username": "admin",
			"db_password": "password",
		},
		BackendConfig: map[string]interface{}{
			"bucket":  bucketForTesting,
			"region":  bucketRegionForTesting,
			"key":     dbStateKey,
			"encrypt": true,
		},
		MigrateState: true,
	}
}

func createDockerOpts(
	t *testing.T,
	dbOpts *terraform.Options,
	terraformDir string) *terraform.Options {
	appStateKey := fmt.Sprintf("%s/%s/terraform.tfstate", t.Name(), random.UniqueId())

	return &terraform.Options{
		TerraformDir: terraformDir,
		Vars: map[string]interface{}{
			"db_remote_state_bucket": dbOpts.BackendConfig["bucket"],
			"db_remote_state_key":    dbOpts.BackendConfig["key"],
			"env_name":               dbOpts.Vars["name"],
		},
		BackendConfig: map[string]interface{}{
			"bucket":  bucketForTesting,
			"region":  bucketRegionForTesting,
			"key":     appStateKey,
			"encrypt": true,
		},
		MigrateState:       true,
		MaxRetries:         3,
		TimeBetweenRetries: 5 * time.Second,
		RetryableTerraformErrors: map[string]string{
			"RequestError: send request failed": "Throttling issue?",
		},
	}
}

func validateDockerApp(t *testing.T, dockerOpts *terraform.Options) {
	albDnsName := terraform.OutputRequired(t, dockerOpts, "alb_dns_name")
	url := fmt.Sprintf("http://%s/data", albDnsName)
	maxRetries := 10
	timeBetweenRetries := 10 * time.Second
	http_helper.HttpGetWithRetryWithCustomValidation(
		t,
		url,
		nil,
		maxRetries,
		timeBetweenRetries,
		func(status int, body string) bool {
			return status == 200 && strings.Contains(body, "Animal Farm")
		},
	)
}
