# docker-laravel-queue


## Configurações adicionais
- criar volume referenciando arquivo: `<path-config>/config.ini:/usr/local/etc/php/conf.d/config.ini:ro`

## Exemplo arquivo `<path-config>/config.ini`

````
post_max_size = 200M
upload_max_filesize = 200M
max_execution_time = 900
memory_limit = 1024M
date.timezone = America/Campo_Grande
max_input_vars = 9000
````
