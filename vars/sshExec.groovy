def call(host, script) {
    sshagent(credentials: ['jenkins-ssh-private-key']) {
        sh "ssh -o StrictHostKeyChecking=no ${host} \'${script.stripIndent()}\'"
    }
}