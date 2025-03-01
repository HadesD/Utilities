import requests
import re
import subprocess
import concurrent.futures

POST_ID = 4135
MAX_EP = 26
EXCEPT_EP = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,16,17,20,22,23,24]

url = "https://boctem.com/wp-admin/admin-ajax.php"
headers = {
    'accept': '*/*',
    'accept-language': 'en-US,en;q=0.9,vi;q=0.8',
    'content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
    'origin': 'https://boctem.com',
    'priority': 'u=1, i',
    'sec-ch-ua': '"Not(A:Brand";v="99", "Google Chrome";v="133", "Chromium";v="133"',
    'sec-ch-ua-mobile': '?0',
    'sec-ch-ua-platform': '"Linux"',
    'sec-fetch-dest': 'empty',
    'sec-fetch-mode': 'cors',
    'sec-fetch-site': 'same-origin',
    'user-agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36',
    'x-requested-with': 'XMLHttpRequest',
}

cookies = {
    '_ga': 'GA1.1.462644625.1740575490',
    '_ga_JTPQCH7H00': 'GS1.1.1740640246.2.1.1740641890.0.0.0',
}

pattern = r'file:\s*"([^"]*)"'

def downloadAndConvert(i, ep_link="3"):
    print("WORKING AT: " + str(i))
    if i in EXCEPT_EP:
        print('Skip')
        return
    data = {
    #    "action": "halim_ajax_player",
        'action': 'halim_play_listsv',
        "nonce": "e5f31e506e",
        "episode": str(i),
        "server": "1",
        "postid": f"{POST_ID}",
        "ep_link": ep_link,
    }

    response = requests.post(url, headers=headers, cookies=cookies, data=data)
    #print(response.text)

    # Regular expression to capture the URL of "file"

    # Search for the pattern
    match = re.search(pattern, response.text)

    # Extract the file URL if a match is found
    if match:
        file_url = match.group(1)
        print(f"File URL: {file_url}")
        command = [
            'ffmpeg',
            '-y',
            '-i', file_url,
            '-http_multiple', '0',
            '-c', 'copy',
            '-bsf:a', 'aac_adtstoasc',
            f'output-{POST_ID}-EP{i:>03}.mp4'
        ]

        # Run the command using subprocess
        try:
            subprocess.run(command, check=True)
            print("FFmpeg command executed successfully.")
        except subprocess.CalledProcessError as e:
            print(f"Error occurred {i}: {e}")
            if e.returncode == 183:
                downloadAndConvert(i, "666")
    else:
        print("File URL not found: " + str(i))

#with concurrent.futures.ThreadPoolExecutor() as executor:
    # Submit each print task to the thread pool
    #executor.map(downloadAndConvert, range(START_EP, MAX_EP))

for i in range(1, MAX_EP+1):
    downloadAndConvert(i)
