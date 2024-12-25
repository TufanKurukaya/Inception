# WordPress + NGINX + MariaDB Docker Projesi

Bu proje, Docker kullanarak NGINX, MariaDB ve PHP-FPM ile eksiksiz bir WordPress ortamı kurmayı sağlar. Hassas bilgiler için gizli yönetimi entegre eder ve güvenli iletişim için SSL sertifikası oluşturmayı içerir.

## Özellikler

- **MariaDB**: Veritabanı yönetimi için
- **NGINX**: Web sunucusu yapılandırması
- **PHP-FPM**: PHP isteklerini işlemek için
- **WordPress**: Kurulum ve yapılandırma
- **Gizli Yönetimi**: Hassas bilgilerin güvenli bir şekilde işlenmesi
- **SSL Sertifikası**: SSL sertifikası oluşturma ve yapılandırma

---

## Gereksinimler

- Sisteminizde Docker ve Docker Compose yüklü olmalıdır.
- Aşağıdaki dosyaları içeren bir `secrets` dizini oluşturun:
  - `db_root_password.txt`: MariaDB root şifresini içerir.
  - `db_password.txt`: WordPress veritabanı kullanıcı şifresini içerir.
  - `credentials.txt`: Aşağıdaki anahtar-değer çiftlerini içerir:
    ```
    MYSQL_USER=<veritabani_kullanici>
    MYSQL_DATABASE=<veritabani_adi>
    ADMIN_EMAIL=<admin_email>
    ADMIN_PASSWORD=<admin_sifre>
    WP_ADMIN_NAME=<wp_admin_kullanici_adi>
    WP_USER_LOGIN=<wp_kullanici_adi>
    WP_USER_PASSWORD=<wp_kullanici_sifre>
    WP_USER_EMAIL=<wp_kullanici_email>
    WP_HOST=<mariadb_servis_adi>
    SUBJECT=<SSL_konusu>
    KEY=/etc/nginx/ssl/nginx.key
    CRT=/etc/nginx/ssl/nginx.crt
    ```
- Aşağıdaki anahtar-değer çiftlerini içeren bir `.env` dosyası oluşturun:
    ```
    DOMAIN_NAME=<domain_name>
    TITLE=<site_title>
    ```

---

## Dizin Yapısı

```
.
├── Makefile
├── secrets
│   ├── credentials.txt
│   ├── db_password.txt
│   └── db_root_password.txt
├── srcs
│   ├── .env
│   ├── docker-compose.yml
│   └── requirements
│       ├── mariadb
│       │   ├── Dockerfile
│       │   └── tools
│       │       └── entrypoint.sh
│       ├── nginx
│       │   ├── conf
│       │   │   └── nginx.conf
│       │   └── tools
│       │       └── entrypoint.sh
│       └── wordpress
│           ├── conf
│           │   └── www.conf
│           └── tools
│               └── entrypoint.sh
```

---

## Servisler Hakkında

### 1. MariaDB
- **Dockerfile**: MariaDB konteynerini oluşturur.
- **tools/entrypoint.sh**:
  - Veritabanı başlangıç yapılandırmasını gerçekleştirir.
  - `mysql_install_db` komutu ile MariaDB sistem tablolarını oluşturur.
  - Gerekli kullanıcıları ve veritabanlarını, `MYSQL_USER`, `MYSQL_DATABASE`, ve `MYSQL_PASSWORD` bilgilerini kullanarak tanımlar.
  - `mysqld` servisini başlatır ve bağlantı izinlerini yapılandırır.
- **Gizli Bilgiler**:
  - Root şifresi ve kullanıcı bilgileri `secrets` dosyalarından okunur.

### 2. NGINX
- **Dockerfile**: NGINX konteynerini oluşturur.
- **conf/nginx.conf**:
  - HTTPS desteği sağlar ve SSL sertifikalarını kullanır.
  - PHP isteklerini `fastcgi_pass` direktifi ile WordPress konteynerine yönlendirir.
  - Statik dosyalar için root dizinini `/var/www/html` olarak ayarlar.
- **tools/entrypoint.sh**:
  - SSL sertifikalarını `openssl` komutu ile oluşturur.
  - NGINX yapılandırmasını dinamik olarak, `DOMAIN_NAME`, `KEY`, ve `CRT` değişkenlerine göre günceller.
  - NGINX servisini başlatır.

### 3. WordPress
- **Dockerfile**:
  - PHP-FPM ve gerekli PHP uzantıları ile WordPress ortamını oluşturur.
  - `wp-cli` aracını indirir ve yapılandırır.
- **tools/entrypoint.sh**:
  - WordPress dosyalarını indirir ve `wp-config.php` dosyasını oluşturur.
  - `wp-cli` kullanarak WordPress kurulumunu tamamlar.
  - Admin ve kullanıcı hesaplarını oluşturur.
- **conf/www.conf**:
  - PHP-FPM için yapılandırma dosyasıdır.
  - WordPress PHP isteklerini işlemek için `wordpress:9000` adresini dinler.
- **Gizli Bilgiler**:
  - WordPress kullanıcı bilgileri ve veritabanı bilgileri `secrets` dizininden okunur.

---

## Projeyi Çalıştırma

1. Bu depoyu klonlayın:
   ```bash
   git clone https://github.com/TufanKurukaya/Inception.git
   cd Inception
   ```

2. Docker imajlarını oluşturun:
   ```bash
   make build
   ```

3. `secrets` dizinini oluşturun ve gerekli dosyaları doldurun:
   ```bash
   mkdir secrets
   echo "root_sifreniz" > secrets/db_root_password.txt
   echo "veritabani_sifreniz" > secrets/db_password.txt
   cat <<EOF > secrets/credentials.txt
   MYSQL_USER=kullanici
   MYSQL_DATABASE=veritabani
   ADMIN_EMAIL=admin@example.com
   ADMIN_PASSWORD=admin_sifre
   WP_ADMIN_NAME=admin_kullanici
   WP_USER_LOGIN=kullanici_adi
   WP_USER_PASSWORD=kullanici_sifre
   WP_USER_EMAIL=kullanici@example.com
   WP_HOST=mariadb
   SUBJECT="/C=TR/ST=Sehir/L=Sehir/O=Kurum/OU=Departman/CN=domain.com"
   KEY=/etc/nginx/ssl/nginx.key
   CRT=/etc/nginx/ssl/nginx.crt
   EOF
   ```

4. `.env` dosyasını oluşturun:
   ```bash
   echo "DOMAIN_NAME=yourdomain.com" > srcs/.env
   echo "TITLE=Your WordPress Site" >> srcs/.env
   ```

5. Konteynerleri başlatın:
   ```bash
   make up
   ```

6. WordPress sitesine erişin:
   Tarayıcınızda `.env` dosyasında belirtilen `DOMAIN_NAME` adresine gidin.

---

## Önemli Notlar

- **Gizli Bilgi Yönetimi**: Tüm hassas bilgiler `secrets` dizininden güvenli bir şekilde yüklenir. Dizin izinlerinin doğru olduğundan emin olun.
- **SSL Sertifikaları**: Sertifikalar mevcut değilse sistem tarafından otomatik olarak oluşturulur.
- **Hata Ayıklama**: Her servis için loglar ilgili konteynerlerde bulunur. Hata ayıklama için `docker logs <container_name>` komutunu kullanabilirsiniz.

---
