#!/usr/bin/env groovy 

pipeline {
	agent any
    stages {
		stage('database') {
			steps {
				script {
					def image = docker.build("database:dev", "./database")
				}
			}
		}
		stage('application') {
			steps {
				script {
					def image = docker.build("application:dev", "./application")
				}
			}
		}		
		stage('gitblit') {
			steps {
				script {
					def image = docker.build("gitblit:dev", "./gitblit")
				}
			}
		}		
	}
}


