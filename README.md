### YAML formating for Dynamic scheduling of Tekton workloads using Triggers

For EventListener Section

```yaml
apiVersion: triggers.tekton.dev/v1beta1
kind: EventListener
metadata:
  name: gitlab-event-listener
spec:
  serviceAccountName: gitlab-listener-sa
  triggers:
    - triggerRef: gitlab-listener-trigger
  resources:
    kubernetesResource:
      serviceType: NodePort
```

For Trigger Section

```yaml
apiVersion: triggers.tekton.dev/v1beta1
kind: Trigger
metadata:
  name: gitlab-listener-trigger
spec:
  interceptors:
    - name: "verify-gitlab-payload"
      ref:
        name: "gitlab"
        kind: ClusterInterceptor
      params:
        - name: secretRef
          value:
            secretName: "gitlab-secret"
            secretKey: "secretToken"
        - name: eventTypes
          value:
            - "Push Hook"
  bindings:
    - ref: binding
  template:
    ref: template
```

For Secret Section
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: gitlab-secret
type: Opaque
stringData:
  secretToken: "1234567"
```

For TriggerBinding Section

```yaml
apiVersion: triggers.tekton.dev/v1beta1
kind: TriggerBinding
metadata:
  name: binding
spec:
  params:
    - name: gitrevision
      value: $(body.checkout_sha)
    - name: gitrepositoryurl
      value: $(body.repository.git_http_url)
```

For TriggerTemplate Section

```yaml
apiVersion: triggers.tekton.dev/v1beta1
kind: TriggerTemplate
metadata:
  name: template
spec:
  params:
    - name: gitrevision
    - name: gitrepositoryurl
  resourcetemplates:
    - apiVersion: tekton.dev/v1beta1
      kind: TaskRun
      metadata:
        generateName: gitlab-run-
      spec:
        taskSpec:
          resources:
            inputs:
              - name: source
                type: git
          steps:
            - image: ubuntu
              script: |
                #! /bin/bash
                ls -al $(inputs.resources.source.path)
        resources:
          inputs:
            - name: source
              resourceSpec:
                type: git
                params:
                  - name: revision
                    value: $(tt.params.gitrevision)
                  - name: url
                    value: $(tt.params.gitrepositoryurl)
```