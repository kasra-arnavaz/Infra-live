package test

import (
	"github.com/gruntwork-io/terratest/modules/terraform"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"testing"
	"fmt"
	"time"
)

func TestAlbExample(t *testing.T){
	t.Parallel()
	opts := &terraform.Options{
		TerraformDir: "../live/dev/networking/alb/alb",
		Vars: map[string]interface{}{
			"name": fmt.Sprintf("test-%s", random.UniqueId()),
		},
	}
	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)
	albDnsName := terraform.OutputRequired(t, opts, "alb_dns_name")
	url := fmt.Sprintf("http://%s", albDnsName)
	expectedStatus := 404
	expectedBody := "404: page not found"
	maxRetries := 10
	timeBetweenRetries := 10 * time.Second
	http_helper.HttpGetWithRetry(
		t,
		url,
		nil,
		expectedStatus,
		expectedBody,
		maxRetries,
		timeBetweenRetries,
	)
}