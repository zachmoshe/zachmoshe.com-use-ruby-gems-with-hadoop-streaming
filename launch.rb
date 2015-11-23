#! /usr/bin/env ruby

require 'aws-sdk-core'

AWS_KEY = ''
AWS_SECRET = ''
LOG_URI = "s3://mybucket/myfolder"
EC2_KEY_NAME = ''
S3_BUCKET = ''

Aws.config[:region] = 'eu-west-1'
Aws.config[:credentials] = Aws::Credentials.new AWS_KEY, AWS_SECRET  # or set Aws credentials via profile/role

emr = Aws::EMR::Client.new 

res = emr.run_job_flow( 
    name: 'my-test-cluster',
    service_role: 'EMR_DefaultRole',
    job_flow_role: 'EMR_EC2_DefaultRole',
    release_label: 'emr-4.2.0', 
    log_uri: LOG_URI,

    instances: { 
        keep_job_flow_alive_when_no_steps: true,
        instance_count: 1, 
        master_instance_type: 'm3.xlarge', 
        slave_instance_type: 'm3.xlarge',
        ec2_key_name: EC2_KEY_NAME,
    },
    bootstrap_actions: [ 
        { 
            name: 'Installing Ruby', 
            script_bootstrap_action: { path: "s3://#{S3_BUCKET}/bootstrap.sh", args: [] },
        } 
    ],
    steps: [
    	{
    		name: 'Setup Hadoop Debugging',
    		action_on_failure: 'TERMINATE_CLUSTER',
    		hadoop_jar_step: {
    			jar: 'command-runner.jar',
    			args: [ "state-pusher-script" ]
    		},
    	}
    ],
)
cluster_id = res.job_flow_id

emr.add_job_flow_steps(
    job_flow_id: cluster_id, 
    steps: [
        {
            name: 'Running mr-job', 
            action_on_failure: 'CONTINUE', 
            hadoop_jar_step: {
                jar: '/usr/lib/hadoop/hadoop-streaming.jar', 
                args:[
                    "-files", "s3://#{S3_BUCKET}/bundler_run.sh", 
                    "-archives", "s3://#{S3_BUCKET}/mr-job.tar.gz#app", 
                    "-mapper", "bash bundler_run.sh app ./mapper.rb",
                    "-reducer", "bash bundler_run.sh app ./reducer.rb",
                    "-input", "s3://#{S3_BUCKET}/input.txt", 
                    "-output", "s3://#{S3_BUCKET}/output.txt"
                ],
            },
        },
    ]
)
