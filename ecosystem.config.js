module.exports = {
	apps : [
		{
			name : 'protagonist',
			script : './server/server.js',
			instances : 10,
			exec_mode : 'cluster',
			wait_ready : true,
			listen_timeout : 50000,
			kill_timeout : 5000,
		}
	]
} 