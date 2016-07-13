#Tổng quan về OpenHab
##1.OpenHab là gì ? 

Openhab là một phần mềm mã nguồn mở có chức năng là bộ điều khiển trung tâm, với khả năng kết nối giao tiếp và điều khiển tới nhiều loại thiết bị khác nhau trong hệ thống SmartHome.
OpenHab cung cấp nhiều giao diện người dùng (web site, android, ios….) giúp cho quá trình làm việc với OpenHab dễ dàng và thuận tiện hơn.
Diễn giải theo quan điểm cá nhân: OpenHab như một phần mềm quản lí, nó cung cấp các addons giúp hỗ trợ việc kết nối các thiết bị phần cứng vào một cách dễ dàng nhất (tuy nhiên bị giới hạn trong các phần cứng mà nó hỗ trợ). Sau khi kết nối, thì OpenHab và các thiết bị sẽ giao tiếp vỡi nhau, và OpenHab sẽ có được thông tin (state) gửi từ các thiết bị, cùng với đó, các thiết bị có thể nhận được các lệnh điều khiển từ OpenHab.

***

##2.Cấu trúc của OpenHab

![alt text][architecture]
[architecture]: https://raw.githubusercontent.com/ngocluanbka/IoT/master/architecture.png "OpenHab Architecture"

OpenHab Runtime được deploy trên OSGi Framework (framework này vận hành theo cơ chế pub/sub), nó sử dụng nền tảng Java solution và cần JVM để chạy. Hiện tại thì OpenHab đang hỗ trợ đến phiên bản JDK8, còn JDK9 thì lỗi không hiểu tại sao. :)) 
Dựa trên OSGi, OpenHab tích hợp các kiến trúc mô-đun hóa, và tích hợp rất nhiều thành phần vào nhau (như hình trên).

###2.1. Giao tiếp
OpenHaB cung cấp 2 kênh giao tiếp tính
1. Giao tiếp không đồng bộ qua Event bus
2. Cung cấp một kho lưu trữ trạng thái, và người dùng có thể truy vấn trạng thái từ kho lưu trữ này.

####Event Bus
Event bus là service lõi của OpenHab, có nhiệm vụ thông báo cho các thành phần khác trong hệ thống về các sự kiện và cập nhật từ các gói bên ngoài.
Có 2 kiểu Event chính:
1. Command để thực hiện các hành động, hoặc thay đổi trạng thái của item/device
2. Cập nhật trạng thái và thông áo về thay đổi trạng thái của một số thiết bị.
(ví dụ event1) thì như mình gửi lệnh bật điều hòa, và sau đó điều hòa sẽ gửi lại trạng thái cập nhật thành công bằng event2)

Các giao thức binding (kết nối tới phần cứng) đều giao tiếp qua Event Bus. 

####Item Repository
IR là thành phần kết nối tới Event Bus và luôn giữ trạng thái của toàn bộ các items.  Trạng thái của các item trong IR luôn là trạng thái hiện tại của items. 
IR được sử dụng trong nhiều hoàn  cảnh, điển hình nhất là cập nhật trạng thái của các items trên giao diện.

![alt text][IR]
[IR]: https://raw.githubusercontent.com/ngocluanbka/IoT/master/IR.png "Item Repository"


####Sitemap
OpenHab sử dụng cấu hình văn bản cho giao diện và đó chính là sitemap, sitemap là một cây cấu trúc gồm các widget, các widget này định nghĩa UI và nội dung của nó. Widget có thể là các item, hoặc các controller, status…. Blabla.

##3.Giao diện, một số file và thư mục để config Open
![alt text][UI]
[UI]: https://raw.githubusercontent.com/ngocluanbka/IoT/master/ui.png "Giao diện OpenHab"

Trong giao diện này thể hiện 1 phòng khách với 2 thiết bị: nhiệt kế và đèn. 

Tiếp đây là diễn giải 1 số file và thư mục cần chú ý để có thể lập trình được 1 giao diện quản lí cho OpenHab.

(Phiên bản Openhab đang làm việc 1.8.3)
###3.1 File openhab.cfg
khi bắt đầu với project Openhab thì cần tạo file này và copy nội từ file openhab_default.conf sang. Đây là file config tổng của OpenHab (để thực hiện biding và kết nối tới các thiết bị khác thì để phải config trển file này).
Tất cả các config cho các thiết bị hỗ trợ đều được đánh comment và có các tham số, nên khi nào dùng thì vào tìm kiếm và thay thế là xong.
###3.2 Thư mục addons
Thư mục sẽ chứa các file addons (đuôi .jar) được cung cấp sẵn. Ví dụ khi muốn kết nối tới một bộ zwave thì cần phải copy file org.openhab.binding.zwave-1.8..3.jar vào trong thư mục addons này.
###3.3 Thư mục configuration/sitemap
đây là thư mục chứa giao diện (frontend của openhab). Ví dụ như giao diện trên thì trong thư mục sẽ có file demo.sitemap như sau.
```
sitemap default label="My Smart Home"
{
    Frame label="Living Room" {
        Text item=Temperature1
        Switch item=Light1
    }
}
```
###3.4 Thư mục configuration/items
Thư mục sẽ chưa những khai báo về các thiết bị, định nghĩa các trạng thái, giao tiếp của thiết bị   tương ứng với bảng điều khiển trong sitemap.
###3.5 Thư mục configuration/script
các script trong thư mục này giúp định nghĩa các luật theo ý của người dùng. Ví dụ bạn muốn đặt 1 luật là, nếu nhiệt độ lớn hơn 30 độ thì bật điều hòa, thì sẽ viết trong thư mục này.

```if (nhiệt độ >30 )
{
	sendCommand(ON, điều hòa).
}
```
###3.6 Thư mục configuration/rules
Thư mục này giúp định nghĩa các luật. Ví dự như với 1 conmand bật điều hòa ở trên. Thì điều hòa nhận lệnh ON. Tuy nhiên ý nghĩa của Lệnh On có thể được viết lại trong Rules.

#Cài đặt OpenHab
Hiên tại thì bản image của Docker đã được em viết lại (chỉ còn 144MB). Mọi người vào trong folder dockerized đọc README để biết cách cài đặt.