import hudson.model.*
import jenkins.model.*
import hudson.slaves.*
import hudson.slaves.EnvironmentVariablesNodeProperty.Entry
import hudson.plugins.sshslaves.verifiers.*

// ssh host key verification
SshHostKeyVerificationStrategy hostKeyVerificationStrategy = new KnownHostsFileKeyVerificationStrategy();

// launch slave agents via SSH
ComputerLauncher launcher = new hudson.plugins.sshslaves.SSHLauncher(
        "jenkins-slave", // Host
        22, // Port
        "ssh-slave-user-private-key", // Credentials
        (String)null, // JVM Options
        (String)null, // JavaPath
        (String)null, // Prefix Start Slave Command
        (String)null, // Suffix Start Slave Command
        (Integer)null, // Connection Timeout in Seconds
        (Integer)null, // Maximum Number of Retries
        (Integer)null, // The number of seconds to wait between retries
        hostKeyVerificationStrategy // Host Key Verification Strategy
);

// create the default slave
Slave default_slave = new DumbSlave(
        "jenkins-slave",
        "/home/jenkins",
        launcher);
default_slave.nodeDescription = "Slave";
default_slave.numExecutors = 4;
default_slave.labelString = "default_slave";
default_slave.mode = Node.Mode.NORMAL;
default_slave.retentionStrategy = new RetentionStrategy.Always();

// create the job builder slave
Slave job_builder_slave = new DumbSlave(
        "jenkins-job-builder",
        "/home/jenkins",
        launcher);
job_builder_slave.nodeDescription = "JJB Executer";
job_builder_slave.numExecutors = 1;
job_builder_slave.labelString = "job_builder_slave";
job_builder_slave.mode = Node.Mode.EXCLUSIVE;
job_builder_slave.retentionStrategy = new RetentionStrategy.Always();

// add the slaves to the jenkins instance
Jenkins.instance.addNode(default_slave);
Jenkins.instance.addNode(job_builder_slave);
