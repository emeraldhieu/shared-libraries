# Shared Libaries

This project was born to support writing Jenkins Job Pipeline.

### 1) withSsh

`withSsh` allows Jenkins to run commands in an SSH way to a specified server by using a given credential called `jenkins-ssh-private-key`

Securely copying files from place to place can be done by

```groovy
withSsh {
	sh "scp -o StrictHostKeyChecking=no -r anyFolder ubuntu@xx.xxx.xx.xx:/path/to/somewhere
}
```

### 2) sshExec

`sshExec` is used for executing remote commands on a specified server.

Calling `docker-compose` on the remote server can be done by

```groovy
sshExec 'ubuntu@xx.xxx.xx.xx',
    '''\
    #!/usr/bin/env bash
    
    set -e
    
    cd /path/to/somewhere
    
    docker-compose -f app.yml up -d --force-recreate
    '''
```

### 2) deployEcs

`deployEcs` updates existing ECS Task Definition and force deployment on existing ECS Service.

Changing current directory and deploying new docker image can be done by
```groovy
stage('Deploy') {
    steps {
        dir('deployment/dev') {
            deployEcs("${IMAGE_URI}", "${PROJECT_NAME}", "${CLUSTER_NAME}")
        }
    }
}
```

This method requires a `taskDefinitionTemplate.json` of the ECS Task Definition located at `<your-project>/deployment/dev`.

```json
{
  "containerDefinitions": [
    {
      "someProperty": "someValue"
    }
  ]
}
```

### References

+ [Jenkins Shared Libraries](https://jenkins.io/doc/book/pipeline/shared-libraries)
+ [Groovy Multi-line string](https://beta.groovy-lang.org/syntax.html#_triple_single_quoted_string)

