package terraform

import (
	"dagger.io/dagger"

	"universe.dagger.io/terraform"
)

let tfversion = "1.1.7"

dagger.#Plan & {
	client: filesystem: "./data": read: contents: dagger.#FS

	actions: {
		// Terraform init
		init: terraform.#Init & {
			directory: client.filesystem."./data".read.contents
			version:   tfversion // defaults to latest
		}

		// Terraform plan
		plan: terraform.#Plan & {
			directory: init.output
			version:   tfversion
		}

		// Implemnt any further actions here. tfsec, trivy, you name it

		// Terraform apply
		apply: terraform.#Apply & {
			directory: plan.output
			version:   tfversion
		}
	}
}
