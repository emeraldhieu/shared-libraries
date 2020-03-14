import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

def now() {
    def now = LocalDateTime.now()
    def dateTimeFormatter = DateTimeFormatter.ofPattern("yyy-MM-dd-HH-mm-ss")
    return now.format(dateTimeFormatter)
}