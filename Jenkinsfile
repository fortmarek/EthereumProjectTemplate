String slackChannel = "ci-kosik"
String hockeyID = "45c05b143f9b492795cdc9ef87f75326"
String gitURL = "git@gitlab.ack.ee:iOS/kosik.git"

node('ios') {
    try {
        stage('Checkout') {
            git url: gitURL, branch: env.BRANCH, credentialsId: '59cc374b-147c-4113-a09f-f0979890048d'
        }

        stage('Prepare') {
            sh("security unlock -p ${MACHINE_PASSWORD} ~/Library/Keychains/login.keychain")
            sh("bundle install")
        }

        stage('Pods') {
            sh("bundle exec fastlane pods")
        }

        stage('Test') {
            if (env.RUN_TESTS.toString().toBoolean()) {
                sh('bundle exec fastlane test type:unit')
                junit allowEmptyResults: true, testResults: 'fastlane/test_output/report.junit'
            }
        }

        stage('Build IPA') {
            sh("bundle exec fastlane beta")
        }

        stage('Upload to HockeyApp')  {
            step([$class: 'HockeyappRecorder', applications: [[apiToken: '321f431b3e354ecd96595cc947a1ff74', downloadAllowed: true, filePath: 'outputs/App.ipa', dsymPath: 'outputs/App.app.dSYM.zip', tags: 'android, internal, ios', mandatory: false, notifyTeam: false, releaseNotesMethod: [$class: 'ChangelogReleaseNotes'], uploadMethod: [$class: 'VersionCreation', appId: hockeyID]]], debugMode: false, failGracefully: false])
        }
    }
    catch (e) {
        currentBuild.result = "FAILURE"
        throw e
    }
    finally {
        notifyBuild(currentBuild.result)
    }
}

def notifyBuild(String buildStatus) {
    // build status of null means successful
    buildStatus =  buildStatus ?: 'SUCCESS'

    // Default values
    def author = getAuthorName()
    def workspace = pwd()
    def changelog = ""//readFile "${workspace}/${env.CHANGELOG_PATH}"
    def color = 'warning'
    def summary = "Build #$env.BUILD_NUMBER ${env.JOB_NAME} status *${buildStatus.toLowerCase()}* started by $author (<$env.BUILD_URL|open>)\n" +
        changelog

    // Override default values based on build status
    if (buildStatus == 'SUCCESS') {
        color = "good"
    }
    else if (buildStatus == "FAILURE") {
        color = "danger"
    }

    // Send notifications
    slackSend message: summary, channel: slackChannel, color: color
}
