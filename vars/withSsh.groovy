def call(Closure nestedSteps) {
    sshagent(credentials: ['jenkins-ssh-private-key']) {
        nestedSteps();
    }
}