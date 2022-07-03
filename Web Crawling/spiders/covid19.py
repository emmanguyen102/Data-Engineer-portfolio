from dataclasses import replace
import scrapy
import re

class Covid19Spider(scrapy.Spider):
    name = 'covid19'
    allowed_domains = ['web.archive.org']

    # function to get rid of VNese accent
    def no_accent(self, s):
        s = re.sub(r'[àáạảãâầấậẩẫăằắặẳẵ]', 'a', s)
        s = re.sub(r'[ÀÁẠẢÃĂẰẮẶẲẴÂẦẤẬẨẪ]', 'A', s)
        s = re.sub(r'[èéẹẻẽêềếệểễ]', 'e', s)
        s = re.sub(r'[ÈÉẸẺẼÊỀẾỆỂỄ]', 'E', s)
        s = re.sub(r'[òóọỏõôồốộổỗơờớợởỡ]', 'o', s)
        s = re.sub(r'[ÒÓỌỎÕÔỒỐỘỔỖƠỜỚỢỞỠ]', 'O', s)
        s = re.sub(r'[ìíịỉĩ]', 'i', s)
        s = re.sub(r'[ÌÍỊỈĨ]', 'I', s)
        s = re.sub(r'[ùúụủũưừứựửữ]', 'u', s)
        s = re.sub(r'[ƯỪỨỰỬỮÙÚỤỦŨ]', 'U', s)
        s = re.sub(r'[ỳýỵỷỹ]', 'y', s)
        s = re.sub(r'[ỲÝỴỶỸ]', 'Y', s)
        s = re.sub(r'[Đ]', 'D', s)
        s = re.sub(r'[đ]', 'd', s)

        marks_list = [u'\u0300', u'\u0301', u'\u0302', u'\u0303', u'\u0306',u'\u0309', u'\u0323']

        for mark in marks_list:
            s = s.replace(mark, '')

        return s

    def start_requests(self):
        yield scrapy.Request(url='https://web.archive.org/web/20210907023426/https://ncov.moh.gov.vn/vi/web/guest/dong-thoi-gian', 
                             callback=self.parse)

    def parse(self, response):
        for timeline in response.xpath('//div[@class="timeline-sec"]/ul'):
            
            # get the raw text for time and lines containing new cases
            time = timeline.xpath('.//li/div[@class="timeline"]/div[@class="timeline-detail"]/div[@class="timeline-head"]/h3/text()')\
                           .extract_first()
            line_containing_cases = timeline.xpath('.//li/div[@class="timeline"]/div[@class="timeline-detail"]/div[@class="timeline-content"]/p[2]/text()')\
                                            .extract_first()

            # transform the line to get new cases
            # 1. replace the "." between numbers
            new_cases = line_containing_cases.replace(".", "")
            # 2. get rid of VNese accent
            new_cases = self.no_accent(new_cases)
            # 3. get an array of match value based on regex
            new_cases = re.findall( r'(\d+).CA', new_cases)
            # 4. if array is empty, new_cases as "NaN", otherwise take the first element in array
            # array containing only 1 value 
            if len(new_cases) != 0:
                new_cases = new_cases[0]
            else:
                new_cases = "NaN"

            # yield the final scraped result
            yield{
                'time': time,
                'new_cases': new_cases
            }

        # "tiep theo" button 
        next_button_url = response.xpath('//ul[@class="lfr-pagination-buttons pager"]/li[2]/a/@href')\
                                  .extract_first()

        # recursion to go till the last "tiep theo" button and perform the same parse function
        if next_button_url:
            yield scrapy.Request(next_button_url, callback=self.parse)

