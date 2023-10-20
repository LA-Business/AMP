# Menggunakan image Nginx sebagai dasar
FROM nginx

# Menyalin file HTML Anda ke direktori root Nginx di dalam container
COPY index.html /usr/share/nginx/html/index.html

# Jika Anda memiliki file dependensi, Anda dapat menyalinnya juga
# COPY dependency.js /usr/share/nginx/html/dependency.js
# COPY style.css /usr/share/nginx/html/style.css

# Port yang akan digunakan oleh Nginx (default 80)
EXPOSE 80

# Perintah untuk menjalankan Nginx saat container dijalankan
CMD ["nginx", "-g", "daemon off;"]
