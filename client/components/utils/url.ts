import path from "path";

const baseUrl = "http://localhost:4000";

export function createUrl(url: string) {
  return new URL(path.join(baseUrl, url));
}
