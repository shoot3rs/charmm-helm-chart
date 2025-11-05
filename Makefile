package:
	helm package charmm
	helm repo index .

lint:
	helm lint charmm

template:
	helm template charmm-helm-chart charmm --values charmm/values.yaml

bundle:
	make lint
	make template
	make package
