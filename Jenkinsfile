#!/usr/bin/env groovy 

pipeline {
	agent any
	stages {
		stage('nginx-proxy') {
			steps {
				script {
					def image = docker.build("nginx-proxy:dev", "./nginx-proxy")
				}
			}
		}
		stage('jenkins-master') {
			steps {
				script {
					def image = docker.build("jenkins-master:dev", "./jenkins-master")
				}
			}
		}
		stage('jenkins-slave') {
			steps {
				script {
					def image = docker.build("jenkins-slave:dev", "./jenkins-slave")
				}
			}
		}
		stage('jenkins-job-builder') {
			steps {
				script {
					def image = docker.build("jenkins-job-builder:dev", "./jenkins-job-builder")
				}
			}
		}
		stage('jenkins-slave-build-essential') {
			steps {
				script {
					def image = docker.build("jenkins-slave-build-essential:dev", "./jenkins-slave-build-essential")
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
		stage('application') {
			steps {
				script {
					def image = docker.build("application:dev", "./application")
				}
			}
		}
		stage('database') {
			steps {
				script {
					def image = docker.build("database:dev", "./database")
				}
			}
		}
	}
}
