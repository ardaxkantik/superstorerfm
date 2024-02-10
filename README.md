# superstorerfm
Superstore dataset RFM Analysis

RFM Analizi için Veri Hazırlığı

Superstore veri seti üzerinde RFM analizi gerçekleştirmek için ilk adım, gerekli veri setini oluşturmaktır. Bu, her bir müşterinin satın alma tarihleri, harcamaları ve alışveriş sıklıkları gibi bilgileri içermelidir.

RFM Metriklerini Hesaplama

RFM analizi için recency (yenilik), frequency (sıklık) ve monetary (para) metriklerini hesaplayın. Bu adımda, her müşteri için recency, frequency ve monetary değerlerini belirleyeceksiniz.

RFM Skorlarını Oluşturma

Her bir metrik için müşterilere skorlar atayarak RFM skorlarını oluşturun. Bu skorlar genellikle 1 ile 5 arasında olabilir, 5 en yüksek, 1 ise en düşük skoru temsil eder.

RFM Skorlarını Kombine Etme

Elde edilen recency_score, frequency_score ve monetary_score'u birleştirerek her müşteri için toplam RFM skorunu hesaplayın.


Müşteri Segmentasyonu

Son olarak, belirlenen RFM skorlarına göre müşterileri segmente edin. Örneğin, müşterileri "Hibernating", "Can't lose", "Champions" gibi kategorilere ayırabilirsiniz.
