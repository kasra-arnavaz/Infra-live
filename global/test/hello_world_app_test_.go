package test

import (
	"fmt"
	"testing"
	"time"
	"strings"
	"github.com/gruntwork-io/terratest/modules/terraform"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
)

func TestHelloWorldAppExample(t *testing.T) {
	t.Parallel()
	opts := &terraform.Options{
		TerraformDir: "../live/dev/services/hello-world-app",
		Vars: map[string]interface{}{
			"name": fmt.Sprintf("test-%s", random.UniqueId()),
			"cluster_name": fmt.Sprintf("test-cluster-%s", random.UniqueId()),
			"alb_name": fmt.Sprintf("test-alb-%s", random.UniqueId()),
		},
		MaxRetries: 3,
		TimeBetweenRetries: 5 * time.Second,
		RetryableTerraformErrors: map[string]string{
			"RequestError: send request failed": "Throttling issue?",
		},
	}
	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)
	albDnsName := terraform.OutputRequired(t, opts, "alb_dns_name")
	url := fmt.Sprintf("http://%s", albDnsName)
	maxRetries := 10
	timeBetweenRetries := 10 * time.Second
	http_helper.HttpGetWithRetryWithCustomValidation(
		t,
		url,
		nil,
		maxRetries,
		timeBetweenRetries,
		func(status int, body string) bool {
			return status == 200 && strings.Contains(body, "Hello, World")
		},
	)
}