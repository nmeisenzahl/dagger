// Deploy with Terraform
// https://www.terraform.io

package terraform

import (
    "dagger.io/dagger"

	  "universe.dagger.io/docker"
)

// Terraform apply
#Apply: {
	// Terraform version
	version: string | *"latest"

	// Source code
	directory: dagger.#FS

	_run: docker.#Build & {
		steps: [
			docker.#Pull & {
				source: "hashicorp/terraform:\(version)"
			},

			// Copy source
			docker.#Copy & {
				dest:     "/src"
				contents: directory
			},
			
			// Run apply
			docker.#Run & {
				command: {
					name: "apply"
					args: ["-input=false", "tfplan.out"]
				}
				workdir: "/src"
			}
		]
	}
}
