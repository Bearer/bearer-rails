def label() {
    def value = "bearer-ruby-${UUID.randomUUID().toString()}"
    return value
}


pipeline {
    agent {
        kubernetes {
        label label()
        defaultContainer 'jnlp'
        yamlFile '.jenkins/stack.yml'
        }
    } // and agent

    stages {
        stage("Rubocop") {
            steps {
                container("ruby261") {
                    ansiColor('xterm') {
                        sh "apk add --update git make build-base"
                        sh "bundle --jobs 20 --retry 5 --path=vendor"
                        sh "bundle exec rubocop -c .rubocop.yml"
                    }
                }
            }
        }//end stage

        stage("Tests") {
            steps {
                container("ruby261") {
                    ansiColor('xterm') {
                        sh "bin/test"
                    }
                }
            }
        }//end stage
    }// end stages
} // end pipeline
