import hudson.model.*
import jenkins.model.*
import hudson.slaves.*
import hudson.slaves.EnvironmentVariablesNodeProperty.Entry
import hudson.plugins.sshslaves.verifiers.*

// Pick one of the strategies from the comments below this line
SshHostKeyVerificationStrategy hostKeyVerificationStrategy = new KnownHostsFileKeyVerificationStrategy()
    //= new KnownHostsFileKeyVerificationStrategy() // Known hosts file Verification Strategy
    //= new ManuallyProvidedKeyVerificationStrategy("<your-key-here>") // Manually provided key Verification Strategy
    //= new ManuallyTrustedKeyVerificationStrategy(false /*requires initial manual trust*/) // Manually trusted key Verification Strategy
    //= new NonVerifyingKeyVerificationStrategy() // Non verifying Verification Strategy

// Define a "Launch method": "Launch slave agents via SSH"
ComputerLauncher launcher = new hudson.plugins.sshslaves.SSHLauncher(
        "jenkins-slave", // Host
        22, // Port
        "ssh-slave-private-key", // Credentials
        (String)null, // JVM Options
        (String)null, // JavaPath
        (String)null, // Prefix Start Slave Command
        (String)null, // Suffix Start Slave Command
        (Integer)null, // Connection Timeout in Seconds
        (Integer)null, // Maximum Number of Retries
        (Integer)null, // The number of seconds to wait between retries
        hostKeyVerificationStrategy // Host Key Verification Strategy
)

// Define a "Permanent Agent"
Slave default_slave = new DumbSlave(
        "jenkins-slave",
        "/home/jenkins-slave",
        launcher)
default_slave.nodeDescription = "Slave"
default_slave.numExecutors = 4
default_slave.labelString = "default_slave"
default_slave.mode = Node.Mode.NORMAL
default_slave.retentionStrategy = new RetentionStrategy.Always()

Slave job_builder_slave = new DumbSlave(
        "jenkins-job-builder",
        "/home/jenkins-slave",
        launcher)
job_builder_slave.nodeDescription = "JJB Executer"
job_builder_slave.numExecutors = 1
job_builder_slave.labelString = "job_builder_slave"
job_builder_slave.mode = Node.Mode.EXCLUSIVE
job_builder_slave.retentionStrategy = new RetentionStrategy.Always()

//List<Entry> env = new ArrayList<Entry>();
//env.add(new Entry("key1","value1"))
//env.add(new Entry("key2","value2"))
//EnvironmentVariablesNodeProperty envPro = new EnvironmentVariablesNodeProperty(env);

//agent.getNodeProperties().add(envPro)

// Create a "Permanent Agent"
Jenkins.instance.addNode(default_slave)
Jenkins.instance.addNode(job_builder_slave)

return "Node has been created successfully."
