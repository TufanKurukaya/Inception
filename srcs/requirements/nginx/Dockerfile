# Alpine Linux'un son sürümünü base image olarak kullan
FROM alpine:latest

# Gerekli paketleri ve Nginx'i yükle
RUN apk update && apk add --no-cache nginx \
    && rm -rf /var/cache/apk/*

# Nginx için gerekli dizinleri oluştur
RUN mkdir -p /run/nginx

# Nginx konfigürasyon dosyasını kopyala
COPY ./conf/wordpress.conf /etc/nginx/conf.d/wordpress.conf
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

# Nginx'i başlatmak için komut
CMD ["nginx", "-g", "daemon off;"]
