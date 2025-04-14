import json
import boto3
import qrcode
import time
import io
import base64
import os

s3 = boto3.client('s3')
BUCKET_NAME = os.environ['BUCKET_NAME']

def lambda_handler(event, context):
    headers = {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'OPTIONS,POST',
        'Content-Type': 'application/json'
    }

    # Handle OPTIONS request
    if event.get('httpMethod') == 'OPTIONS':
        return {
            'statusCode': 200,
            'headers': headers,
            'body': ''
        }

    try:
        # Parse the request body
        body = json.loads(event.get('body', '{}'))
        url = body.get('url')

        if not url:
            return {
                'statusCode': 400,
                'headers': headers,
                'body': json.dumps({
                    'success': False,
                    'error': 'URL is required'
                })
            }

        # Generate QR code
        qr = qrcode.QRCode(
            version=1,
            error_correction=qrcode.constants.ERROR_CORRECT_L,
            box_size=10,
            border=4,
        )
        qr.add_data(url)
        qr.make(fit=True)
        img = qr.make_image(fill_color="black", back_color="white")

        # Convert image to base64
        buffered = io.BytesIO()
        img.save(buffered, format="PNG")
        img_str = base64.b64encode(buffered.getvalue()).decode()

        # Save to S3
        filename = f"qr-{int(time.time())}.png"
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=filename,
            Body=buffered.getvalue(),
            ContentType='image/png'
        )

        # Generate S3 URL
        qr_code_url = f"https://{BUCKET_NAME}.s3.amazonaws.com/{filename}"

        return {
            'statusCode': 200,
            'headers': headers,
            'body': json.dumps({
                'success': True,
                'qr_code_url': qr_code_url,
                'base64_image': f"data:image/png;base64,{img_str}"  # Include base64 image
            })
        }

    except Exception as e:
        return {
            'statusCode': 500,
            'headers': headers,
            'body': json.dumps({
                'success': False,
                'error': str(e)
            })
        }
