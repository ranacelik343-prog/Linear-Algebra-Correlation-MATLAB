%% ========================================================================
%  T.C. İSTANBUL 29 MAYIS ÜNİVERSİTESİ
%  MÜHENDİSLİK VE DOĞA BİLİMLERİ FAKÜLTESİ
%  BİLGİSAYAR MÜHENDİSLİĞİ BÖLÜMÜ
%
%  BIL102 LİNEER CEBİR DERSİ - DÖNEM SONU PROJESİ
%  Proje Konusu: Korelasyon Katsayısının Vektörsel Uzay ve Lineer Cebirsel Analizi
%
%  PROJE GRUP ÜYELERİ:
%  - Irmak SARICA
%  - Rana ÇELİK
%  - Eda Naz ULUSOY
%  - Rümeysa ÖZDEMİR
% ========================================================================

clear; clc; close all;

%% 1. ADIM: VERİ SETİNİN EXCEL DOSYASINDAN YÜKLENMESİ
% Analiz edilecek emlak verilerini içeren Excel dosyasının adı tanımlanır.
dosya_adi = 'emlak_verisi.xlsx';

% Excel dosyasındaki sütun başlıklarının (türkçe karakter vb.) korunması sağlanır.
opts = detectImportOptions(dosya_adi);
opts.VariableNamingRule = 'preserve'; 

% Veriler sayısal bir matris (X) olarak belleğe yüklenir.
X = readmatrix(dosya_adi, opts);

% Grafik eksenlerinde kullanılmak üzere sütun isimleri kaydedilir.
sutun_isimleri = opts.VariableNames;


%% 2. ADIM: LİNEER CEBİR YÖNTEMLERİYLE KORELASYON HESABI (MATRİS İŞLEMLERİ)

% A) Veriyi Ortalamadan Arındırma (Centering)
% Her bir değişkenin ortalaması bulunarak veri matrisinden çıkarılır. 
% Bu işlem matematiksel olarak tüm veri vektörlerini orijine (başlangıç noktasına) taşır.
mu = mean(X);
Z = X - mu; 

% B) İç Çarpım (Dot Product) Matrisinin Hesaplanması
% Z matrisinin transpozu ile kendisinin çarpımı (Z' * Z), veri vektörlerinin 
% birbiriyle olan iç çarpımlarını ve dolayısıyla varyans/kovaryans yapısını verir.
ic_carpim = Z' * Z;

% C) Vektör Normlarının (Boylarının) Hesaplanması
% Her bir veri vektörünün Öklid normu (boyu) hesaplanır. Korelasyon katsayısının
% paydasında yer alan norm değerleri matris formuna dönüştürülecektir.
normlar = sqrt(sum(Z.^2));

% D) Normalizasyon Köşegen Matrisinin (D) Oluşturulması
% Vektör normlarının tersi alınarak köşegen elemanlara yerleştirilir. 
% Bu işlem, sonuçların [-1, 1] aralığına sıkıştırılmasını (normalize edilmesini) sağlar.
D = diag(1 ./ normlar);

% E) Pearson Korelasyon Matrisinin Elde Edilmesi
% Lineer cebirsel formül: R = D * (Z' * Z) * D
% Bu işlem istatistiksel Pearson korelasyon katsayısını matris çarpımıyla hesaplar.
korelasyon_matrisi = D * ic_carpim * D;


%% 3. ADIM: AKADEMİK GÖRSELLEŞTİRME VE ÖZEL RENK DÜZENLEMESİ

% Hesaplanan matris sonuçları doğrulama amaçlı komut penceresine yazdırılır.
disp('--- HESAPLANAN KORELASYON MATRİSİ ---');
disp(korelasyon_matrisi);

% Proje sunumuna uygun, beyaz arka plana sahip temiz bir figür penceresi açılır.
figure('Name', 'BIL102 Lineer Cebir Korelasyon Analizi', 'Color', [1 1 1]); 

% Isı haritası (Heatmap) oluşturulur.
h = heatmap(sutun_isimleri, sutun_isimleri, korelasyon_matrisi);

% --- ÖZEL PEMBE (MAGENTA) DİVERGING COLORMAP MATRİSİ ---
% -1 (negatif ilişki) için açık pembe, 0 (ilişkisiz) için beyaz,
% +1 (pozitif güçlü ilişki) için koyu magenta/pembe tonları doğrusal olarak üretilir.
n = 256; 
r1 = linspace(1, 1, n/2)';     g1 = linspace(0.75, 1, n/2)'; b1 = linspace(0.85, 1, n/2)';
r2 = linspace(1, 0.85, n/2)';   g2 = linspace(1, 0.08, n/2)'; b2 = linspace(1, 0.48, n/2)';

ozel_pembe_harita = [r1, g1, b1; r2, g2, b2];
h.Colormap = ozel_pembe_harita;
h.ColorLimits = [-1 1]; % Sınırlar [-1, +1] aralığına sabitlenir.

% --- METİN VE ETİKETLERİN SİMSİYAH VE OKUNAKLI YAPILMASI ---
% Başlık ve eksen isimleri TeX formatı kullanılarak tamamen siyah renge zorlanır.
h.Title = '\color{black}Lineer Cebir Tabanlı Pearson Korelasyon Isı Haritası';
h.XLabel = '\color{black}Değişkenler';
h.YLabel = '\color{black}Değişkenler';

% Tablo içi okunabilirlik ayarları
h.FontSize = 14;              % Yazı boyutu akademik standartlara çekildi.
h.CellLabelColor = 'black';    % Hücre içerisindeki korelasyon değerleri NET SİYAH yapıldı.
h.GridVisible = 'on';          % Hücre sınır çizgileri belirginleştirildi.

% Eksen etiketlerinin gri kalmasını önlemek için etiketlerin önüne dinamik siyah kodu eklenir.
h.XDisplayLabels = strcat('\color{black}', h.XDisplayLabels);
h.YDisplayLabels = strcat('\color{black}', h.YDisplayLabels);

disp('Proje kodu başarıyla çalıştırıldı ve görselleştirme tamamlandı.');