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

        stage('Analyze Project') {
            steps {
                sh 'flutter analyze'
            }
        }

        stage('Run Tests') {
            steps {
                sh 'flutter test'
            }
        }

        stage('Build APK') {
            steps {
                sh 'flutter build apk --release'
            }
        }
    }
}
