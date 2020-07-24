output "bastion_ip" {
  value       = module.ec2.bastion_ip
}


output "MAGENTO_INSTALLATION_COMMAND" {
  value = <<SSHCONFIG
  
/var/www/html/magento2/bin/magento setup:install \
  --backend-frontname=admin \
  --admin-firstname=${var.magento_first_name} \
  --admin-lastname=${var.magento_last_name} \
  --admin-email=${var.magento_email} \
  --admin-user=${var.magento_admin_user} \
  --admin-password=${var.magento_password} \
  --base-url=http://${var.magento_url}/ \
  --db-host=${module.rds.db_address} \
  --db-name=magento \
  --db-user=magento \
  --db-password=magentomagento1 \
  --session-save=redis \
  --session-save-redis-host=${module.redis.session_cache_nodes.0.address} \
  --cache-backend=redis \
  --cache-backend-redis-server=${module.redis.default_cache_nodes.0.address} \
  --currency=USD \
  --timezone=America/Chicago \
  --language=en_US \
  --use-rewrites=1 \
  --search-engine elasticsearch7 \
  --elasticsearch-host ${module.es.es_endpoint} \
  --elasticsearch-port 80
SSHCONFIG
}