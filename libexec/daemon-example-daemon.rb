require 'json'

DaemonKit::Application.running!

config = DaemonKit::Config.load('redis')

redis = Redis.new(host: config['host'], port: config['port'])

DaemonKit.logger.info("pidfile is #{DaemonKit.configuration.pid_file}")

loop do
  jid = SecureRandom.hex(12)
  title = "daemon title #{jid}"
  body = "daemon body #{jid}"
  message = { class: 'Delayer', args: [title, body], jid: jid, retry: true }
  redis.lpush('opsworks.example.sidekiq:queue:default', JSON.generate(message))
  sleep 30
end
