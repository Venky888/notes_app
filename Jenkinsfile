pipeline {
    agent any

    environment {
        FLUTTER_HOME = "/Users/venkateshdevarampati/flutter"
        PATH = "${env.PATH}:${FLUTTER_HOME}/bin"
    }

    stages {

        stage('Check Flutter') {
            steps {
                sh 'flutter doctor'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'flutter pub get'
            }
        }

        stage('Build APK') {
            steps {
                sh 'flutter build apk --release'
            }
        }
        stage('Copy APK') {
            steps {
                sh '''
        mkdir -p "/Users/venkateshdevarampati/Downloads/Flutter Workspace/notes_app/apk"

        cp build/app/outputs/flutter-apk/app-release.apk \
        "/Users/venkateshdevarampati/Downloads/Flutter Workspace/notes_app/apk/"
        '''
            }
        }

    }
}
