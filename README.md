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


_________________________________________________________________________________________________________________________________________________________________________________________


The first step in performing RFM analysis on the Superstore dataset is to create the necessary dataset. This should include information such as purchase dates, expenditures, and shopping frequencies for each customer.

Calculating RFM Metrics

For the RFM analysis, calculate the recency, frequency, and monetary metrics. In this step, you will determine the recency, frequency, and monetary values for each customer.

Creating RFM Scores

Assign scores to customers for each metric to create RFM scores. These scores are typically between 1 and 5, with 5 representing the highest score and 1 representing the lowest.

Combining RFM Scores

Combine the recency_score, frequency_score, and monetary_score obtained to calculate the total RFM score for each customer.

Customer Segmentation

Finally, segment the customers based on the determined RFM scores. For example, you can categorize customers into segments such as "Hibernating," "Can't lose," "Champions," and so on.
