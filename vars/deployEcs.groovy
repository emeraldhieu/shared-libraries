def call(String imageUri, String projectName, String clusterName) {
    /**
     * Read content of "deploy-ecs.bash" and write it to the current directory of Jenkins.
     * If you want to change the current directory, nest this function call inside dir()
     * For example,
     * dir('/path-to-the-location-you-want-to-execute-this-script') {
     *     deployEcs(...)
     * }
     * Refer to https://jenkins.io/doc/pipeline/steps/workflow-basic-steps/#dir-change-current-directory
     */
    def scriptContent = libraryResource 'deploy-ecs.bash'
    writeFile(file: 'deploy-ecs.bash', text: scriptContent)

    sh "bash deploy-ecs.bash $imageUri $projectName $clusterName"
}