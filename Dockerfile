# Menggunakan image Nginx sebagai dasar
FROM nginx

# Menyalin file HTML Anda ke direktori root Nginx di dalam container
COPY . /usr/share/nginx/html/
RUN mv /usr/share/nginx/html/dutaplay.html /usr/share/nginx/html/index.html

# Port yang akan digunakan oleh Nginx (default 80)
EXPOSE 80

# Perintah untuk menjalankan Nginx saat container dijalankan
CMD ["nginx", "-g", "daemon off;"]
