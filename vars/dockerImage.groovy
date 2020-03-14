def getImageTag(branchName) {
    def revision = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()
    def slashIndex = branchName.lastIndexOf("/")
    if (slashIndex != -1) {
        def lastSegment = branchName.substring(slashIndex + 1)
        if (lastSegment ==~ /(\d+)\.(\d+)\.(\d+)/) {
            return lastSegment
        }
        return lastSegment + "-" + revision
    }
    return branchName + "-" + revision
}